#/usr/bin/sh
###############################################################################
##                                                                           ##
##          Script to build GCC toolchain for Renesas RX processor           ##
##                                                                           ## 
##---------------------------------------------------------------------------##
## File:     build-renesas-toolchain.sh                                      ##
## Author:   Ulrich Becker <u.becker@gsi.de>                                 ##
## Company:  GSI Helmholtz Centre for Heavy Ion Research GmbH                ##
## Date:     13.08.2019                                                      ##
## Revision:                                                                 ##
###############################################################################
TARGET="rx-elf"
ENABLE_CPP=true

make_third_stage()
{
   [ $VERBOSE ] && echo "INFO: Nothing additional work for target RENESAS RX in third stage."
}

source build-toolchain.sh

#=================================== EOF ======================================
