#/usr/bin/sh
###############################################################################
##                                                                           ##
##       Script to build GCC toolchain for a native target (e.g. x86)        ##
##                                                                           ## 
##---------------------------------------------------------------------------##
## File:     build-lm32-toolchain.sh                                         ##
## Author:   Ulrich Becker <u.becker@gsi.de>                                 ##
## Company:  GSI Helmholtz Centre for Heavy Ion Research GmbH                ##
## Date:     04.06.2019                                                      ##
## Revision:                                                                 ##
###############################################################################
TARGET=$(uname -m)

ENABLE_CPP=true
ENABLE_ADA=true
ENABLE_FORTRAN=true
ENABLE_D=true
ENABLE_OBJ_C=true
ENABLE_OBJ_CPP=true
ENANLE_GO=true
ENABLE_BRIG=true


make_third_stage()
{
   [ $VERBOSE ] && echo "INFO: Nothing additional work for target $(uname -m) in third stage."
}

source build-toolchain.sh

#=================================== EOF ======================================
