#/usr/bin/sh
###############################################################################
##                                                                           ##
##        Script to build GCC toolchain for Atmel AVR Microcontroller        ##
##                                                                           ## 
##---------------------------------------------------------------------------##
## File:     build-avr-toolchain.sh                                          ##
## Author:   Ulrich Becker <u.becker@gsi.de>                                 ##
## Company:  GSI Helmholtz Centre for Heavy Ion Research GmbH                ##
## Date:     23.10.2018                                                      ##
## Revision:                                                                 ##
###############################################################################
TARGET="avr"
ENABLE_CPP=true

VERSION_CONFIG_FILE="./gcc_versions.conf"
source $VERSION_CONFIG_FILE

AVR_LIBC_URL="http://download.savannah.gnu.org/releases/avr-libc/avr-libc-${AVR_LIBC_VERSION}.tar.bz2"
AVR_DUDE_URL="http://download.savannah.gnu.org/releases/avrdude/avrdude-${AVR_DUDE_VERSION}.tar.gz"
AVR_SIMULAVR_URL="http://download.savannah.nongnu.org/releases/simulavr/simulavr-${AVR_SIMULAVR_VERSION}.tar.gz"

make_avr_libc()
{
   local oldDir=$(pwd)
   local avrLibCdir=${SOURCE_DIR}/avr-libc-${AVR_LIBC_VERSION}
   cd ${avrLibCdir}

   ./configure --prefix=$PREFIX --build=$(./config.guess) --host=$TARGET 2>${ERROR_LOG_FILE}
   [ "$?" != "0" ] && end 1

   make 2>${ERROR_LOG_FILE}
   [ "$?" != "0" ] && end 1

   make install 2>${ERROR_LOG_FILE}
   [ "$?" != "0" ] && end 1

   cd $oldDir
}

make_simul_avr()
{
#TODO configure: error: 
#    Could not locate libbfd.so/libbfd.a and/or bfd.h.
#   Please use the --with-bfd=<path to your libbfd library>

   local oldDir=$(pwd)
   local simulAvrDir=${SOURCE_DIR}/simulavr-${AVR_SIMULAVR_VERSION}
   cd ${simulAvrDir}

   ./configure --prefix=$PREFIX 2>${ERROR_LOG_FILE}
   [ "$?" != "0" ] && end 1

   make 2>${ERROR_LOG_FILE}
   [ "$?" != "0" ] && end 1

   make install 2>${ERROR_LOG_FILE}
   [ "$?" != "0" ] && end 1

   cd $oldDir
}

make_avr_dude()
{
   local oldDir=$(pwd)
   local avrDudeDir=${SOURCE_DIR}/avrdude-${AVR_DUDE_VERSION}
   cd ${avrDudeDir}

   ./configure --prefix=$PREFIX 2>${ERROR_LOG_FILE}
   [ "$?" != "0" ] && end 1

   make 2>${ERROR_LOG_FILE}
   [ "$?" != "0" ] && end 1 

   make install 2>${ERROR_LOG_FILE}
   [ "$?" != "0" ] && end 1

   cd $oldDir
}

make_third_stage()
{
   [ $VERBOSE ] && echo "INFO: Entering third stage."
   make_avr_libc
#   make_simul_avr
   make_avr_dude
}

source build-toolchain.sh

#=================================== EOF ======================================
