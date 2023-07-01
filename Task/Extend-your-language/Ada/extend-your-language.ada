with Ada.Text_IO; use Ada.Text_IO;

procedure Test_If_2 is

   type Two_Bool is range 0 .. 3;

   function If_2(Cond_1, Cond_2: Boolean) return Two_Bool is
      (Two_Bool(2*Boolean'Pos(Cond_1)) + Two_Bool(Boolean'Pos(Cond_2)));

begin
   for N in 10 .. 20 loop
      Put(Integer'Image(N) & " is ");
      case If_2(N mod 2 = 0, N mod 3 = 0) is
	 when 2#11# => Put_Line("divisible by both two and three.");
	 when 2#10# => Put_Line("divisible by two, but not by three.");
	 when 2#01# => Put_Line("divisible by three, but not by two.");
	 when 2#00# => Put_Line("neither divisible by two, nor by three.");
      end case;
   end loop;
end Test_If_2;
