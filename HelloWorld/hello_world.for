!
! Test-program for Fortran compiler
!
! To compile this example type:
!
! gfortran hello_world.for -o hello_fortran 
!
! Note:
! Don't forget to actualize the environment variable "PATH" before:
! export PATH=/path/to/my/compiler_binary:$PATH
!
! Or name the full path to the compiler:
! /path/to/my/compiler_binary/gfortran hello_world.for -o hello_fortran
!
      program hello_world
          print *,"Hello world in Fortran!"
      end program hello_world
