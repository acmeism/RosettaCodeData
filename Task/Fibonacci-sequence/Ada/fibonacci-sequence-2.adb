with Ada.Text_IO;  use Ada.Text_IO;

procedure Test_Fibonacci is
   function Fibonacci (N : Natural) return Natural is
      This : Natural := 0;
      That : Natural := 1;
      Sum  : Natural;
   begin
      for I in 1..N loop
         Sum  := This + That;
         That := This;
         This := Sum;
      end loop;
      return This;
   end Fibonacci;
begin
   for N in 0..10 loop
      Put_Line (Positive'Image (Fibonacci (N)));
   end loop;
end Test_Fibonacci;
