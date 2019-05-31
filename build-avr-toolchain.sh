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

make_avr_libc()
{
   local oldDir=$(pwd)
   local avrLibCdir=${SOURCE_DIR}/avr-libc-${AVR_LIBC_VERSION}
   cd ${avrLibCdir}
   
   ./configure --prefix=$PREFIX --build=$(./config.guess) --host=$TARGET
   [ "$?" != "0" ] && end 1

   make
   [ "$?" != "0" ] && end 1
   
   make install
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

   ./configure --prefix=$PREFIX
   [ "$?" != "0" ] && end 1

   make
   [ "$?" != "0" ] && end 1

   make install
   [ "$?" != "0" ] && end 1

   cd $oldDir
}

make_avr_dude()
{
   local oldDir=$(pwd)
   local avrDudeDir=${SOURCE_DIR}/avrdude-${AVR_DUDE_VERSION}
   cd ${avrDudeDir}
   
   ./configure --prefix=$PREFIX
   [ "$?" != "0" ] && end 1

   make 
   [ "$?" != "0" ] && end 1
   
   make install
   [ "$?" != "0" ] && end 1

   cd $oldDir
}

make_third_stage()
{
   make_avr_libc
#   make_simul_avr
   make_avr_dude
}

source build-toolchain.sh

#=================================== EOF ======================================
