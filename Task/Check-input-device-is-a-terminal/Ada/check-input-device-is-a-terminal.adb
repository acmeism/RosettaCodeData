with Ada.Text_IO;          use Ada.Text_IO;
with Interfaces.C_Streams; use Interfaces.C_Streams;

procedure Test_tty is
begin
   if Isatty(Fileno(Stdin)) = 0 then
      Put_Line(Standard_Error, "stdin is not a tty.");
   else
      Put_Line(Standard_Error, "stdin is a tty.");
   end if;
end Test_tty;
