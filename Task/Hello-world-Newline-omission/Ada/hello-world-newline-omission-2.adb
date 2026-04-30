with Ada.Text_IO;
with Ada.Text_IO.Text_Streams;

procedure Goodbye_World is
    stdout: Ada.Text_IO.File_Type := Ada.Text_IO.Standard_Output;
begin
    String'Write(Ada.Text_IO.Text_Streams.Stream(stdout), "Goodbye World");
end Goodbye_World;
