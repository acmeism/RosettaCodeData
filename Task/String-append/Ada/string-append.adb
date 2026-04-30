with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Text_IO.Unbounded_Io; use Ada.Text_IO.Unbounded_IO;

procedure String_Append is
   Str : Unbounded_String := To_Unbounded_String("Hello");
begin
   Append(Str, ", world!");
   Put_Line(Str);
end String_Append;
