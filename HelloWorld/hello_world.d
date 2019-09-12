/*
 Test-program for D compiler

 To compile this example type:

 gdc hello_world.d -o hello_d

 Note:
 Don't forget to actualize the environment variable "PATH" before:
 export PATH=/path/to/my/compiler_binary:$PATH

 Or name the full path to the compiler:
 /path/to/my/compiler_binary/gdc hello_world.d -o hello_d
*/
 
import std.stdio;

void main() 
{ 
   writefln( "Hello world in D!" );
}
