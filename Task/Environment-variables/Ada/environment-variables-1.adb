with Ada.Environment_Variables; use Ada.Environment_Variables;
with Ada.Text_Io; use Ada.Text_Io;

procedure Print_Path is
begin
   Put_Line("Path : " & Value("PATH"));
end Print_Path;
