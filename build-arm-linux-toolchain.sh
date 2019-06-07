#/usr/bin/sh
###############################################################################
##                                                                           ##
##        Script to build GCC toolchain for Linux ARM architectures          ##
##                                                                           ## 
##---------------------------------------------------------------------------##
## File:     build-arm-linux-toolchain.sh                                    ##
## Author:   Ulrich Becker <u.becker@gsi.de>                                 ##
## Company:  GSI Helmholtz Centre for Heavy Ion Research GmbH                ##
## Date:     07.06.2019                                                      ##
## Revision:                                                                 ##
###############################################################################
TARGET="arm-linux-eabi"
ENABLE_CPP=true

VERSION_CONFIG_FILE="./gcc_versions.conf"
source $VERSION_CONFIG_FILE

make_third_stage()
{
   [ $VERBOSE ] && echo "INFO: Nothing additional work for target $TARGET in third stage."
}

source build-toolchain.sh

#=================================== EOF ======================================
