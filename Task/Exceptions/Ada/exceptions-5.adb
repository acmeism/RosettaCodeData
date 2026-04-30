with Ada.Exceptions;  use Ada.Exceptions;
with Ada.Text_IO;     use Ada.Text_IO;

procedure Main is
begin
   ...
   Raise_Exception (Foo_Error'Identity, "This is the exception message");
   ..
exception
   when Error : others =>
      Put_Line ("Something is wrong here" & Exception_Information (Error));
end Main;
