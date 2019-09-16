/*
 Test-program for native GO-compiler

 To compile this example type:

 gccgo hello_world.go -o hello_go

 Note:
 Don't forget to actualize the environment variable "PATH" before:
 export PATH=/path/to/my/compiler_binary:$PATH
 
 Or name the full path to the compiler:
 /path/to/my/compiler_binary/gcc gccgo hello_world.go -o hello_go
*/

package main

import "fmt"

func main() {
    fmt.Println("Hello, world in GO")
}
