#/usr/bin/sh
###############################################################################
##                                                                           ##
##       Script to build GCC toolchain for Motorola 68000-family (m68k)      ##
##                                                                           ## 
##---------------------------------------------------------------------------##
## File:     build-m68k-toolchain.sh                                         ##
## Author:   Ulrich Becker <u.becker@gsi.de>                                 ##
## Company:  GSI Helmholtz Centre for Heavy Ion Research GmbH                ##
## Date:     27.11.2019                                                      ##
## Revision:                                                                 ##
###############################################################################
TARGET="m68k-elf"
ENABLE_CPP=true

make_third_stage()
{
   [ $VERBOSE ] && echo "INFO: Nothing additional work for target Motorola M68000 in third stage."
}

source build-toolchain.sh

#=================================== EOF ======================================
