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
   local avrLibCdir=${SOURCE_DIR}/avr-libc-${AVR_LIBC_VERSION}
   ${avrLibCdir}/configure --prefix=$PREFIX --build=$(${avrLibCdir}/config.guess) --host=$TARGET
   make -C ${avrLibCdir}
   make -C ${avrLibCdir} install
}

make_avr_dude()
{
   local oldDir=$(pwd)
   local avrDudeDir=${SOURCE_DIR}/avrdude-${AVR_DUDE_VERSION}
   cd ${avrDudeDir}
   ./configure --prefix=$PREFIX
   make 
   make install
   cd $oldDir
}

make_third_stage()
{
   make_avr_libc
   make_avr_dude
}

source build-toolchain.sh

#=================================== EOF ======================================
