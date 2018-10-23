#!/bin/sh
#
# Script to build lm32 GCC toolchain
#

VERBOSE=true

NEW_LIB_VERSION="1.19.0"
GCC_VERSION="7.3.0"
GDB_VERSION="7.2a"
BINUTILS_VERSION="2.21.1"
MPC_VERSION="1.1.0"
MPFR_VERSION="3.1.0"
GMP_VERSION="5.0.2"

NEW_LIB_URL="ftp://sources.redhat.com/pub/newlib/newlib-${NEW_LIB_VERSION}.tar.gz"
GCC_URL="http://ftp.gnu.org/gnu/gcc/gcc-${GCC_VERSION}/gcc-${GCC_VERSION}.tar.gz"
GDB_URL="http://ftp.gnu.org/gnu/gdb/gdb-${GDB_VERSION}.tar.bz2"
BIN_UTILS_URL="http://ftp.gnu.org/gnu/binutils/binutils-${BINUTILS_VERSION}.tar.bz2"
MPC_URL="https://ftp.gnu.org/gnu/mpc/mpc-${MPC_VERSION}.tar.gz"
MPFR_URL="http://www.mpfr.org/mpfr-${MPFR_VERSION}/mpfr-${MPFR_VERSION}.tar.bz2"
GMP_URL="ftp://ftp.gmplib.org/pub/gmp-${GMP_VERSION}/gmp-${GMP_VERSION}.tar.bz2"

URL_LIST=""

URL_LIST="$URL_LIST $NEW_LIB_URL"
URL_LIST="$URL_LIST $GCC_URL"
URL_LIST="$URL_LIST $GDB_URL"
URL_LIST="$URL_LIST $BIN_UTILS_URL"
URL_LIST="$URL_LIST $MPC_URL"
URL_LIST="$URL_LIST $MPFR_URL"
URL_LIST="$URL_LIST $GMP_URL"

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
            exit 1
         fi
      fi
   done
}

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
         exit 1
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
         exit 1
      fi
 
      [ $VERBOSE ] && echo "INFO: Trying to extract \"$path_file\""
      tar "$tarOption" "$path_file"
      if [ "$?" != "0" ]
      then
         echo "ERROR: By extracting file:  \"$path_file\""
         exit $?
      fi
   done
}

linkList()
{
   if [ ! -d "${SOURCE_DIR}/gcc-${GCC_VERSION}" ]
   then
      echo "ERROR: Directory \"${1}\" not found!"
      exit 1
   fi
   if [ ! -d "$1" ]
   then
      echo "ERROR: Directory \"${1}\" not found!"
      exit 1
   fi
   for i in $2
   do
      local lnkDir="${SOURCE_DIR}/gcc-${GCC_VERSION}/${i}"
      if [ -d "${1}/${i}" ]
      then
         local srcDir="${1}/${i}"
      else
         local srcDir="${1}"
      fi
      rm $lnkDir 2>/dev/null
      [ $VERBOSE ] && echo "INFO: make symbolck link: $srcDir -> $lnkDir"
      ln -s $srcDir $lnkDir
      if [ "$?" != "0" ]
      then
         echo "ERROR: Can't make symbolic link: $srcDir -> $lnkDir" 1>&2
         exit 1
      fi
   done
}


prepare_gcc_build()
{
   local binUtilLinkList="bfd binutils gas gold gprof opcodes ld"
   local newLibLinkList="newlib libgloss"
   local gdbLinkList="gdb"
   local mpcLinkList="mpc"
   local mpfrLinkList="mpfr"
   local gmpLinkList="gmp"
   linkList ${SOURCE_DIR}/binutils-${BINUTILS_VERSION} "$binUtilLinkList"
   linkList ${SOURCE_DIR}/gdb-${GDB_VERSION%[a-z]} "$gdbLinkList"
   linkList ${SOURCE_DIR}/gmp-${GMP_VERSION} "$gmpLinkList"
   linkList ${SOURCE_DIR}/mpc-${MPC_VERSION} "$mpcLinkList"
   linkList ${SOURCE_DIR}/mpfr-${MPFR_VERSION} "$mpfrLinkList"
   linkList ${SOURCE_DIR}/newlib-${NEW_LIB_VERSION} "$newLibLinkList"
}


WORK_DIR=$(pwd)
DOWNLOAD_DIR="${WORK_DIR}/download"
mkdir -p $DOWNLOAD_DIR
cd $DOWNLOAD_DIR

download_if_not_already_done

SOURCE_DIR="${WORK_DIR}/src"
mkdir -p $SOURCE_DIR
cd $SOURCE_DIR

extract_if_not_already_done

prepare_gcc_build


BUILD_DIR="${WORK_DIR}/build"
mkdir -p $BUILD_DIR
cd $BUILD_DIR

${SOURCE_DIR}/gcc-${GCC_VERSION}/configure  --prefix=/usr/mico32 --enable-languages=c --target=lm32-elf --disable-libssp --disable-libgcc
make -j
#make install
#=================================== EOF ======================================
