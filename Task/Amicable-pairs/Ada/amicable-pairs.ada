with Ada.Text_IO; use Ada.Text_IO;

procedure Amicable is

   function Sum_Of_Factors(Num : Integer) return Integer is
      Sum : Integer := 1;
      Test_Nr : Integer := 2;
   begin
      loop
	 if Num mod Test_Nr = 0 then
	    Sum := Sum + Test_Nr;
	    if Test_Nr * Test_Nr /= Num then
	       Sum := Sum + Num / Test_Nr;
	       end if;
	 end if;
	 Test_Nr := Test_Nr + 1;
	 exit when Test_Nr ** 2 > Num;
      end loop;
      return Sum;
   end Sum_Of_Factors;

   Num2 : Integer;
begin
   for Num1 in 4 .. 20_000 loop
      Num2 := Sum_Of_Factors(Num1);
      if Num1 < Num2 then
	 if Num1 = Sum_Of_Factors(Num2) then
	   Put_Line(Integer'Image(Num1) & "," & Integer'Image(Num2));
	 end if;
      end if;
   end loop;
end Amicable;
