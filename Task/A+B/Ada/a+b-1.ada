-- Standard I/O Streams

with Ada.Integer_Text_Io;
procedure APlusB is
   A, B : Integer;
begin
   Ada.Integer_Text_Io.Get (Item => A);
   Ada.Integer_Text_Io.Get (Item => B);
   Ada.Integer_Text_Io.Put (A+B);
end APlusB;
