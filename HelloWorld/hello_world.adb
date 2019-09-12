--
-- Test-program for ADA compiler
--
-- To compile this example type:
--
-- gnatmake hello_world.adb -o hello_ada
--
-- Note:
-- Don't forget to actualize the environment variable "PATH" before:
-- export PATH=/path/to/my/compiler_binary:$PATH
--
-- Or name the full path to the compiler:
-- /path/to/my/compiler_binary/gnatmake hello_world.adb -o hello_ada
--

with Ada.Text_IO;

procedure hello_world is
begin
   Ada.Text_IO.Put_Line( "Hello, world in ADA!" );
end hello_world;
