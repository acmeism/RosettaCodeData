with Ada.Text_IO; with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

procedure Prepend_String is
   S: Unbounded_String := To_Unbounded_String("World!");
begin
   S := "Hello " & S;-- this is the operation to prepend "Hello " to S.
   Ada.Text_IO.Put_Line(To_String(S));
end Prepend_String;
