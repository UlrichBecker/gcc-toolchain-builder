/*
 Test-program for native C-compiler

 To compile this example type:

 gcc hello_world.c -o hello_c

 Note:
 Don't forget to actualize the environment variable "PATH" before:
 export PATH=/path/to/my/compiler_binary:$PATH
 
 Or name the full path to the compiler:
 /path/to/my/compiler_binary/gcc hello_world.c -o hello_c
*/
#include <stdio.h>

int main( void )
{
   printf( "Hello world in C!\n" );
   return 0;
}
