with Ada.Environment_Variables; use Ada.Environment_Variables;
with Ada.Text_Io; use Ada.Text_Io;

procedure Env_Vars is
   procedure Print_Vars(Name, Value : in String) is
   begin
      Put_Line(Name & " : " & Value);
   end Print_Vars;
begin
   Iterate(Print_Vars'access);
end Env_Vars;
