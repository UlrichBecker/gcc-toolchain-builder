#!/bin/sh
###############################################################################
##                                                                           ##
##                  Script to build lm32 GCC toolchain                       ##
##                                                                           ## 
##---------------------------------------------------------------------------##
## File:     build-lm32-toolchain.sh                                         ##
## Author:   Ulrich Becker (u.becker@gsi.de)                                 ##
## Company:  GSI Helmholtzzentrum fuer Schwerionenforschung GmbH             ##
## Date:     23.10.2018                                                      ##
## Revision:                                                                 ##
###############################################################################
START_TIME=$(date +%s)
VERSION_CONFIG_FILE="./gcc_versions.conf"
VERBOSE=true
TARGET="lm32-elf"
ENABLE_CPP=

source $VERSION_CONFIG_FILE

LANGUAGES="c"
[ $ENABLE_CPP ] && LANGUAGES="${LANGUAGES},c++"

NEW_LIB_URL="ftp://sources.redhat.com/pub/newlib/newlib-${NEW_LIB_VERSION}.tar.gz"
GCC_URL="http://ftp.gnu.org/gnu/gcc/gcc-${GCC_VERSION}/gcc-${GCC_VERSION}.tar.gz"
GDB_URL="http://ftp.gnu.org/gnu/gdb/gdb-${GDB_VERSION}.tar.bz2"
BIN_UTILS_URL="http://ftp.gnu.org/gnu/binutils/binutils-${BINUTILS_VERSION}.tar.bz2"
MPC_URL="https://ftp.gnu.org/gnu/mpc/mpc-${MPC_VERSION}.tar.gz"
MPFR_URL="http://www.mpfr.org/mpfr-${MPFR_VERSION}/mpfr-${MPFR_VERSION}.tar.bz2"
GMP_URL="ftp://ftp.gmplib.org/pub/gmp-${GMP_VERSION}/gmp-${GMP_VERSION}.tar.bz2"

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
   echo "Elapsed time: $(seconds2timeFormat $(($(date +%s) - $START_TIME)))"
   exit $1
}

#------------------------------------------------------------------------------
init_url_list()
{
   URL_LIST=""

   if [ ! -n "${GCC_VERSION}" ]
   then
      echo "ERROR: Variable \"GCC_VERSION\" is not set in $VERSION_CONFIG_FILE"
      end 1
   fi
   URL_LIST="$URL_LIST $GCC_URL"

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
         echo "ERROR: By extracting file:  \"$path_file\""
         end $?
      fi
   done
}

#------------------------------------------------------------------------------
linkList()
{
   if [ ! -d "${SOURCE_DIR}/gcc-${GCC_VERSION}" ]
   then
      echo "ERROR: Directory \"${1}\" not found!"
      end 1
   fi
   if [ ! -d "$1" ]
   then
      echo "ERROR: Directory \"${1}\" not found!"
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
   local gdbLinkList="gdb"
   local mpcLinkList="mpc"
   local mpfrLinkList="mpfr"
   local gmpLinkList="gmp"
   [ -n "${BINUTILS_VERSION}" ] && linkList ${SOURCE_DIR}/binutils-${BINUTILS_VERSION} "$binUtilLinkList"
   [ -n "${GDB_VERSION}" ]      && linkList ${SOURCE_DIR}/gdb-${GDB_VERSION%[a-z]} "$gdbLinkList" "."
   [ -n "${GMP_VERSION}" ]      && linkList ${SOURCE_DIR}/gmp-${GMP_VERSION} "$gmpLinkList"
   [ -n "${MPC_VERSION}" ]      && linkList ${SOURCE_DIR}/mpc-${MPC_VERSION} "$mpcLinkList"
   [ -n "${MPFR_VERSION}" ]     && linkList ${SOURCE_DIR}/mpfr-${MPFR_VERSION} "$mpfrLinkList"
   [ -n "${NEW_LIB_VERSION}" ]  && linkList ${SOURCE_DIR}/newlib-${NEW_LIB_VERSION} "$newLibLinkList"
}


#================================= main =======================================
WORK_DIR=$(pwd)

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

BUILD_DIR="${WORK_DIR}/build-${TARGET}-${GCC_VERSION}"
mkdir -p $BUILD_DIR
cd $BUILD_DIR

PREFIX="${HOME}/.local"

${SOURCE_DIR}/gcc-${GCC_VERSION}/configure  --prefix=${PREFIX} \
   --enable-languages=${LANGUAGES} --target=${TARGET} \
   --disable-libssp --disable-libgcc
if [ "$?" != "0" ]
then
   end $?
fi

make -j
if [ "$?" != "0" ]
then
   end $?
fi

make install
if [ "$?" != "0" ]
then
   end $?
fi

[ $VERBOSE ] && echo "*** Success! :-) ***"
end 0

#=================================== EOF ======================================
