//
// Test-program for (native) C++ compiler
//
// To compile this example type:
//
// g++ hello_world.cpp -o hello_cpp
//
// Note:
// Don't forget to actualize the environment variable "PATH" before:
// export PATH=/path/to/my/compiler_binary:$PATH
//
// Or name the full path to the compiler:
// /path/to/my/compiler_binary/g++ hello_world.cpp -o hello_cpp
//
#include <iostream>

using namespace std;

int main( void )
{
   cout << "Hello world in C++!" << endl;
   return 0;
}
