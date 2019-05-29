#/usr/bin/sh
###############################################################################
##                                                                           ##
##         Script to build GCC toolchain for LatticeMicro32 (LM32)           ##
##                                                                           ## 
##---------------------------------------------------------------------------##
## File:     build-lm32-toolchain.sh                                         ##
## Author:   Ulrich Becker <u.becker@gsi.de>                                 ##
## Company:  GSI Helmholtz Centre for Heavy Ion Research GmbH                ##
## Date:     23.10.2018                                                      ##
## Revision:                                                                 ##
###############################################################################

TARGET="lm32-elf"
ENABLE_CPP=true

make_third_stage()
{
   [ $VERBOSE ] && echo "Nothing additional work for target LM32 in third stage."
}

source build-toolchain.sh

#=================================== EOF ======================================
