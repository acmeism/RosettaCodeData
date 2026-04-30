with Ada.Text_Io;
procedure CompileTimeCalculation is

   function Factorial (Int : in Integer) return Integer is
   begin
      if Int > 1 then
         return Int * Factorial(Int-1);
      else
         return 1;
      end if;
   end;

     Fact10 : Integer := Factorial(10);
begin
   Ada.Text_Io.Put(Integer'Image(Fact10));
end CompileTimeCalculation;
