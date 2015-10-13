with Ada.Text_Io;
with Ada.Integer_Text_IO;

procedure Integer_Arithmetic is
   use Ada.Text_IO;
   use Ada.Integer_Text_Io;

   A, B : Integer;
begin
   Get(A);
   Get(B);
   Put_Line("a+b = " & Integer'Image(A + B));
   Put_Line("a-b = " & Integer'Image(A - B));
   Put_Line("a*b = " & Integer'Image(A * B));
   Put_Line("a/b = " & Integer'Image(A / B));
   Put_Line("a mod b = " & Integer'Image(A mod B)); -- Sign matches B
   Put_Line("remainder of a/b = " & Integer'Image(A rem B)); -- Sign matches A
   Put_Line("a**b = " & Integer'Image(A ** B));

end Integer_Arithmetic;
