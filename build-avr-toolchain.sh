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

source build-toolchain.sh

#=================================== EOF ======================================
