with Ada.Text_IO, Generic_Divisors;

procedure Odd_Abundant is
   function Same(P: Positive) return Positive is (P);

   package Divisor_Sum is new Generic_Divisors
     (Result_Type => Natural, None => 0, One => Same, Add =>  "+");

   function Abundant(N: Positive) return Boolean is
      (Divisor_Sum.Process(N) > N);

   package NIO is new Ada.Text_IO.Integer_IO(Natural);

   Current: Positive := 1;

   procedure Print_Abundant_Line
     (Idx: Positive; N: Positive; With_Idx: Boolean:= True) is
   begin
      if With_Idx then
	 NIO.Put(Idx, 6);  Ada.Text_IO.Put(" |");
      else
	 Ada.Text_IO.Put("   *** |");
      end if;
      NIO.Put(N, 12); Ada.Text_IO.Put(" | ");
      NIO.Put(Divisor_Sum.Process(N), 12); Ada.Text_IO.New_Line;
   end Print_Abundant_Line;

begin
   -- the first 25 abundant odd numbers
   Ada.Text_IO.Put_Line(" index |      number | proper divisor sum ");
   Ada.Text_IO.Put_Line("-------+-------------+--------------------");
   for I in 1 .. 25 loop
      while not Abundant(Current) loop
	 Current := Current + 2;
      end loop;
      Print_Abundant_Line(I, Current);
      Current := Current + 2;
   end loop;

   -- the one thousandth abundant odd number
   Ada.Text_IO.Put_Line("-------+-------------+--------------------");
   for I in 26 .. 1_000 loop
      Current := Current + 2;
      while not Abundant(Current) loop
	 Current := Current + 2;
      end loop;
   end loop;
   Print_Abundant_Line(1000, Current);

   -- the first abundant odd number greater than 10**9
   Ada.Text_IO.Put_Line("-------+-------------+--------------------");
   Current := 10**9+1;
   while not Abundant(Current) loop
      Current := Current + 2;
   end loop;
   Print_Abundant_Line(1, Current, False);
end Odd_Abundant;
