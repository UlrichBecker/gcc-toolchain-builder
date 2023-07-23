###############################################################################
##                                                                           ##
##                Include-Script to build GCC toolchains                     ##
##                                                                           ## 
##---------------------------------------------------------------------------##
## File:     build-toolchain.sh                                              ##
## Author:   Ulrich Becker <u.becker@gsi.de>                                 ##
## Company:  GSI Helmholtz Centre for Heavy Ion Research GmbH                ##
## Date:     23.10.2018                                                      ##
## Revision:                                                                 ##
###############################################################################
START_TIME=$(date +%s)

VERBOSE=true

if [ ! -n "$VERSION_CONFIG_FILE" ]
then
   VERSION_CONFIG_FILE="./gcc_versions.conf"
fi
if [ ! -n "$GCC_VERSION" ]
then
   source $VERSION_CONFIG_FILE
fi

if [ ! -n "$PKG_VERSION" ]
then
   PKG_VERSION=GSI
fi

LANGUAGES="c"
[ $ENABLE_CPP ]     && LANGUAGES="${LANGUAGES},c++"
[ $ENABLE_ADA ]     && LANGUAGES="${LANGUAGES},ada"
[ $ENABLE_FORTRAN ] && LANGUAGES="${LANGUAGES},fortran"
[ $ENABLE_D ]       && LANGUAGES="${LANGUAGES},d"
[ $ENABLE_OBJ_C ]   && LANGUAGES="${LANGUAGES},objc"
[ $ENABLE_OBJ_CPP ] && LANGUAGES="${LANGUAGES},obj-c++"
[ $ENANLE_GO ]      && LANGUAGES="${LANGUAGES},go"
[ $ENABLE_BRIG ]    && LANGUAGES="${LANGUAGES},brig"
[ $ENABLE_JAVA ]    && LANGUAGES="${LANGUAGES},java"

GCC_URL="http://ftp.gnu.org/gnu/gcc/gcc-${GCC_VERSION}/gcc-${GCC_VERSION}.tar.gz"
GLIBC_URL="https://ftp.gnu.org/gnu/glibc/glibc-${GLIBC_VERSION}.tar.gz"
UCLIBC_URL="https://downloads.uclibc-ng.org/releases/${UCLIBC_VERSION}/uClibc-ng-${UCLIBC_VERSION}.tar.xz"
#NEW_LIB_URL="ftp://sources.redhat.com/pub/newlib/newlib-${NEW_LIB_VERSION}.tar.gz"
#NEW_LIB_URL="ftp://sourceware.org/pub/newlib/newlib-${NEW_LIB_VERSION}.tar.gz"
NEW_LIB_URL="https://sourceware.org/ftp/newlib/newlib-${NEW_LIB_VERSION}.tar.gz"
GDB_URL="http://ftp.gnu.org/gnu/gdb/gdb-${GDB_VERSION}.tar.gz"
BIN_UTILS_URL="http://ftp.gnu.org/gnu/binutils/binutils-${BINUTILS_VERSION}.tar.bz2"
MPC_URL="https://ftp.gnu.org/gnu/mpc/mpc-${MPC_VERSION}.tar.gz"
MPFR_URL="http://www.mpfr.org/mpfr-${MPFR_VERSION}/mpfr-${MPFR_VERSION}.tar.bz2"
#GMP_URL="ftp://ftp.gmplib.org/pub/gmp-${GMP_VERSION}/gmp-${GMP_VERSION}.tar.bz2"
GMP_URL="https://gmplib.org/download/gmp/gmp-${GMP_VERSION}.tar.bz2"

if [ -n "$PKG_VERSION" ]
then
   ADDITIONAL_CONFIG_ARGS="$ADDITIONAL_CONFIG_ARGS --with-pkgversion=$PKG_VERSION"
fi

ADDITIONAL_CONFIG_ARGS="$ADDITIONAL_CONFIG_ARGS --disable-assembly"


ADDITIONAL_FIRST_STAGE_CONFIG_ARGS="$ADDITIONAL_FIRST_STAGE_CONFIG_ARGS $ADDITIONAL_CONFIG_ARGS"
ADDITIONAL_SECOND_STAGE_CONFIG_ARGS="$ADDITIONAL_SECOND_STAGE_CONFIG_ARGS $ADDITIONAL_CONFIG_ARGS"
ADDITIONAL_SECOND_STAGE_CONFIG_ARGS="$ADDITIONAL_SECOND_STAGE_CONFIG_ARGS --disable-source-highlight"

# ADDITIONAL_SECOND_STAGE_CONFIG_ARGS="$ADDITIONAL_SECOND_STAGE_CONFIG_ARGS --disable-gdb"
#------------------------------------------------------------------------------
seconds2timeFormat()
{
   local time=$1
   local seconds=$(($time % 60))
   time=$(( $(($time - $seconds)) / 60 ))
   local minutes=$(($time % 60))
   time=$(( $(($time - $minutes)) / 60 ))
   local hours=$(($time % 60))

   printf "%01d:%02d:%02d" ${hours} ${minutes} ${seconds}
}

#------------------------------------------------------------------------------
end()
{
   if [ "$1" != "0" ]
   then
      echo "Something was going wrong!... :-/" 1>&2
      echo "Look in the file: $ERROR_LOG_FILE" 1>&2
   fi
   echo "Elapsed time: $(seconds2timeFormat $(($(date +%s) - $START_TIME)))"
   exit $1
}

#------------------------------------------------------------------------------
init_url_list()
{
   URL_LIST=""

   if [ ! -n "${GCC_VERSION}" ]
   then
      echo "ERROR: Variable \"GCC_VERSION\" is not set in $VERSION_CONFIG_FILE" 1>&2
      end 1
   fi
   URL_LIST="$URL_LIST $GCC_URL"

   case ${TARGET} in
      "avr") 
         [ -n "${AVR_LIBC_VERSION}" ]     && URL_LIST="$URL_LIST $AVR_LIBC_URL"
         [ -n "${AVR_DUDE_VERSION}" ]     && URL_LIST="$URL_LIST $AVR_DUDE_URL"
         [ -n "${AVR_SIMULAVR_VERSION}" ] && URL_LIST="$URL_LIST $AVR_SIMULAVR_URL"
      ;;
      *)
         [ -n "${GLIBC_VERSION}" ]    && URL_LIST="$URL_LIST $GLIBC_URL"
      ;;
   esac
   [ -n "${NEW_LIB_VERSION}" ]  && URL_LIST="$URL_LIST $NEW_LIB_URL"
   [ -n "${GDB_VERSION}" ]      && URL_LIST="$URL_LIST $GDB_URL"
   [ -n "${BINUTILS_VERSION}" ] && URL_LIST="$URL_LIST $BIN_UTILS_URL"
   [ -n "${MPC_VERSION}" ]      && URL_LIST="$URL_LIST $MPC_URL"
   [ -n "${MPFR_VERSION}" ]     && URL_LIST="$URL_LIST $MPFR_URL"
   [ -n "${GMP_VERSION}" ]      && URL_LIST="$URL_LIST $GMP_URL"
}

#------------------------------------------------------------------------------
download_if_not_already_done()
{
   for i in $URL_LIST
   do
      if [ -f "$(basename $i)" ]
      then
         [ $VERBOSE ] && echo "INFO: File \"$(basename $i)\" already present."
      else
         [ $VERBOSE ] && echo "INFO: Trying to download: \"$i\""
         wget $i
         if [ "$?" != "0" ]
         then
            echo "ERROR: Unable to download \"$i\"" 1>&2
            end 1
         fi
      fi
   done
}

#------------------------------------------------------------------------------
extract_if_not_already_done()
{
   local tarOption
   for i in $URL_LIST
   do
      local tar_file="$(basename $i)"
      local path_file="${DOWNLOAD_DIR}/${tar_file}"
      if [ ! -f "$path_file" ]
      then
         echo "ERROR: File \"$path_file\" not found!" 1>&2
         end 1
      fi
      local dirName=${tar_file%.tar.*}
      dirName=${dirName%[a-z]}
      if [ -d "$dirName" ]
      then
         [ $VERBOSE ] && echo "INFO: File \"$path_file\" already extrected."
         continue
      fi

      if [ -n "$(echo $tar_file | grep ".tar.bz2")" ]
      then
         tarOption="-xjvf"
      elif [ -n "$(echo $tar_file | grep ".tar.gz")" ]
      then
         tarOption="-xzvf"
      else
         echo "ERROR: Compressed fileformat of \"${tar_file}\" not supported!" 1>&2
         end 1
      fi
 
      [ $VERBOSE ] && echo "INFO: Trying to extract \"$path_file\""
      tar "$tarOption" "$path_file"
      if [ "$?" != "0" ]
      then
         echo "ERROR: By extracting file:  \"$path_file\"" 1>&2
         end 1
      fi
   done
}

#------------------------------------------------------------------------------
linkList()
{
   if [ ! -d "${SOURCE_DIR}/gcc-${GCC_VERSION}" ]
   then
      echo "ERROR: Directory \"${1}\" not found!" 1>&2
      end 1
   fi
   if [ ! -d "$1" ]
   then
      echo "ERROR: Directory \"${1}\" not found!" 1>&2
      end 1
   fi
   for i in $2
   do
      local lnkDir="${SOURCE_DIR}/gcc-${GCC_VERSION}/${i}"
      if [ -d "${1}/${i}" ] && ! [ -n "${3}" ]
      then
         local srcDir="${1}/${i}"
      else
         local srcDir="${1}/${3}"
      fi
      rm $lnkDir 2>/dev/null
      [ $VERBOSE ] && echo "INFO: make symbolck link: $srcDir -> $lnkDir"
      ln -s $srcDir $lnkDir
      if [ "$?" != "0" ]
      then
         echo "ERROR: Can't make symbolic link: $srcDir -> $lnkDir" 1>&2
         end 1
      fi
   done
}

#------------------------------------------------------------------------------
prepare_gcc_build()
{
   local binUtilLinkList="bfd binutils gas gold gprof opcodes ld"
   local newLibLinkList="newlib libgloss"
  # local gdbLinkList="gdb gnulib gdbsupport sim"
   local gdbLinkList="gdb gnulib gdbsupport"
   local mpcLinkList="mpc"
   local mpfrLinkList="mpfr"
   local gmpLinkList="gmp"
   local glibcLinkList="glibc"
   local avrlibcLinkList="avrlibc"
   local avrdudeLinkList="avrdude"
   case ${TARGET} in
      "avr") 
         [ -n "${AVR_LIBC_VERSION}" ] && linkList ${SOURCE_DIR}/avr-libc-${AVR_LIBC_VERSION} "$avrlibcLinkList"
         [ -n "${AVR_DUDE_VERSION}" ] && linkList ${SOURCE_DIR}/avrdude-${AVR_DUDE_VERSION} "$avrdudeLinkList"
      ;;
      *)
         [ -n "${GLIBC_VERSION}" ]    && linkList ${SOURCE_DIR}/glibc-${GLIBC_VERSION} "$glibcLinkList"
      ;;
   esac
   [ -n "${BINUTILS_VERSION}" ] && linkList ${SOURCE_DIR}/binutils-${BINUTILS_VERSION} "$binUtilLinkList"
   [ -n "${GDB_VERSION}" ]      && linkList ${SOURCE_DIR}/gdb-${GDB_VERSION%[a-z]} "$gdbLinkList" "."
   [ -n "${GMP_VERSION}" ]      && linkList ${SOURCE_DIR}/gmp-${GMP_VERSION} "$gmpLinkList"
   [ -n "${MPC_VERSION}" ]      && linkList ${SOURCE_DIR}/mpc-${MPC_VERSION} "$mpcLinkList"
   [ -n "${MPFR_VERSION}" ]     && linkList ${SOURCE_DIR}/mpfr-${MPFR_VERSION} "$mpfrLinkList"
   [ -n "${NEW_LIB_VERSION}" ]  && linkList ${SOURCE_DIR}/newlib-${NEW_LIB_VERSION} "$newLibLinkList"
}

#------------------------------------------------------------------------------
make_first_stage()
{
   [ $VERBOSE ] && echo "INFO: Entering first stage."
   ${SOURCE_DIR}/gcc-${GCC_VERSION}/configure ${CONFIGURE_ARGS} \
      --enable-languages=c ${CONFIG_TARGET} \
      --disable-libssp --disable-libgcc ${ADDITIONAL_FIRST_STAGE_CONFIG_ARGS} \
      2>${ERROR_LOG_FILE}
   [ "$?" != "0" ] && end 1

   mv config.log  configStage1.log

   make -j${MAX_CPU_CORES} all-gcc 2>${ERROR_LOG_FILE}
   [ "$?" != "0" ] && end 1

#   make install-gcc 2>${ERROR_LOG_FILE}
#   [ "$?" != "0" ] && end 1
}

#------------------------------------------------------------------------------
make_second_stage()
{
   [ $VERBOSE ] && echo "INFO: Entering second stage."
   ${SOURCE_DIR}/gcc-${GCC_VERSION}/configure ${CONFIGURE_ARGS} \
      --enable-languages=${LANGUAGES} ${CONFIG_TARGET} \
      ${ADDITIONAL_SECOND_STAGE_CONFIG_ARGS} 2>${ERROR_LOG_FILE}
   [ "$?" != "0" ] && end 1

   mv config.log  configStage2.log

   make -j${MAX_CPU_CORES} 2>${ERROR_LOG_FILE}
   [ "$?" != "0" ] && end 1

   make install 2>${ERROR_LOG_FILE}
   [ "$?" != "0" ] && end 1
}

#================================= main =======================================
WORK_DIR=$(pwd)

#PREFIX="${WORK_DIR}/temp"

export LC_ALL=C
ulimit -s 32768

if [ ! -n "$PREFIX" ]
then
   PREFIX="${HOME}/.local"
fi

if [ ! -n "$MAX_CPU_CORES" ]
then
   MAX_CPU_CORES=4
fi

if [ ! -n "$TARGET" ]
then
   echo "ERROR: Variable \"TARGET\" is not specified!" 1>&2
   end 1
fi

if [ "$TARGET" == "$(uname -m)" ]
then
   CONFIG_TARGET=""
else
   CONFIG_TARGET="--target=${TARGET}"
fi

CONFIGURE_ARGS="--prefix=${PREFIX} --disable-werror"

init_url_list

DOWNLOAD_DIR="${WORK_DIR}/download"
mkdir -p $DOWNLOAD_DIR
cd $DOWNLOAD_DIR

download_if_not_already_done

SOURCE_DIR="${WORK_DIR}/src"
mkdir -p $SOURCE_DIR
cd $SOURCE_DIR

extract_if_not_already_done

prepare_gcc_build

#exit 0

BUILD_DIR="${WORK_DIR}/_build-${TARGET}-${GCC_VERSION}"
if [ -d "$BUILD_DIR" ]
then
   [ $VERBOSE ] && echo "INFO: Deleting old existing build directory this may take a while: $BUILD_DIR"
   rm -rfv --preserve-root $BUILD_DIR
fi
mkdir $BUILD_DIR
cd $BUILD_DIR

ERROR_LOG_FILE=${BUILD_DIR}/error.log

mkdir -p $PREFIX 

if [ -n "$CONFIG_TARGET" ]
then
   make_first_stage
else
   [ $VERBOSE ] && echo "INFO: Native toolchain becomes build, omiting first stage."
fi
make_second_stage
make_third_stage

[ $VERBOSE ] && echo "*** Success! :-) ***"
end 0

#=================================== EOF ======================================
