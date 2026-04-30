with
  Ada.Text_IO,
  Ada.Integer_Text_IO,
  Ada.Strings.Unbounded,
  Ada.Text_IO.Unbounded_IO;

procedure User_Input2 is
   S : Ada.Strings.Unbounded.Unbounded_String;
   I : Integer;
begin
   Ada.Text_IO.Put("Enter a string: ");
   S := Ada.Strings.Unbounded.To_Unbounded_String(Ada.Text_IO.Get_Line);
   Ada.Text_IO.Put_Line(Ada.Strings.Unbounded.To_String(S));
   Ada.Text_IO.Unbounded_IO.Put_Line(S);
   Ada.Text_IO.Put("Enter an integer: ");
   Ada.Integer_Text_IO.Get(I);
   Ada.Text_IO.Put_Line(Integer'Image(I));
end User_Input2;
