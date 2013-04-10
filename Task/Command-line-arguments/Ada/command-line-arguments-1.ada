with Ada.Command_line; use Ada.Command_Line;
with Ada.Text_IO; use Ada.Text_IO;

procedure Print_Commands is
begin
   -- The number of command line arguments is retrieved from the function Argument_Count
   -- The actual arguments are retrieved from the function Argument
   -- The program name is retrieved from the function Command_Name
   Put(Command_Name & " ");
   for Arg in 1..Argument_Count loop
      Put(Argument(Arg) & " ");
   end loop;
   New_Line;
end Print_Commands;
