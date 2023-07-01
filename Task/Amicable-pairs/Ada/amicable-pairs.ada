with Ada.Text_IO, Generic_Divisors; use Ada.Text_IO;

procedure Amicable_Pairs is

   function Same(P: Positive) return Positive is (P);

   package Divisor_Sum is new Generic_Divisors
     (Result_Type => Natural, None => 0, One => Same, Add =>  "+");

   Num2 : Integer;
begin
   for Num1 in 4 .. 20_000 loop
      Num2 := Divisor_Sum.Process(Num1);
      if Num1 < Num2 then
	 if Num1 = Divisor_Sum.Process(Num2) then
	   Put_Line(Integer'Image(Num1) & "," & Integer'Image(Num2));
	 end if;
      end if;
   end loop;
end Amicable_Pairs;
