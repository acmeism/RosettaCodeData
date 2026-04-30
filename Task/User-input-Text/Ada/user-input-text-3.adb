with Ada.Text_IO, Ada.Integer_Text_IO;

procedure User_Input is
   I : Integer;
begin
   Ada.Text_IO.Put ("Enter a string: ");
   declare
      S : String := Ada.Text_IO.Get_Line;
   begin
      Ada.Text_IO.Put_Line (S);
   end;
   Ada.Text_IO.Put ("Enter an integer: ");
   Ada.Integer_Text_IO.Get(I);
   Ada.Text_IO.Put_Line (Integer'Image(I));
end User_Input;
