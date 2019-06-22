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
TARGET="arm-linux-gnueabi"
ENABLE_CPP=true

VERSION_CONFIG_FILE="./gcc_versions.conf"
source $VERSION_CONFIG_FILE

if [ ! -n "$SYSROOT" ]
then
   echo "ERROR: No system root directory defined in variable \"SYSROOT\"!"  1>&2
   exit 1
fi
if [ ! -d "$SYSROOT" ]
then
   echo "ERROR: System root defined in variable \"SYSROOT\" doesn't exist: \"$SYSROOT\"!" 1>&2
   exit 1
fi

SYSROOT_ARG="--with-sysroot=$SYSROOT"

ADDITIONAL_FIRST_STAGE_CONFIG_ARGS=$ADDDITIONAL_CONFIG_ARGS
ADDITIONAL_SECOND_STAGE_CONFIG_ARGS="$SYSROOT_ARG $ADDDITIONAL_CONFIG_ARGS"

make_third_stage()
{
   [ $VERBOSE ] && echo "INFO: Nothing additional work for target $TARGET in third stage."
}

source build-toolchain.sh

#=================================== EOF ======================================
