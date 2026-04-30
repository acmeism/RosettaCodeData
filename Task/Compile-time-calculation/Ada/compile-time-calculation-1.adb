with Ada.Text_Io;
procedure CompileTimeCalculation is
   Factorial : constant Integer := 10*9*8*7*6*5*4*3*2*1;

begin
   Ada.Text_Io.Put(Integer'Image(Factorial));
end CompileTimeCalculation;
