with Ada.Text_IO, Ada.Numerics.Generic_Elementary_Functions;

procedure Benford is

   subtype Nonzero_Digit is Natural range 1 .. 9;
   function First_Digit(S: String) return Nonzero_Digit is
      (if S(S'First) in '1' .. '9'
         then Nonzero_Digit'Value(S(S'First .. S'First))
         else First_Digit(S(S'First+1 .. S'Last)));

   package N_IO is new Ada.Text_IO.Integer_IO(Natural);

   procedure Print(D: Nonzero_Digit; Counted, Sum: Natural) is
      package Math is new Ada.Numerics.Generic_Elementary_Functions(Float);
      package F_IO is new Ada.Text_IO.Float_IO(Float);
      Actual: constant Float := Float(Counted) / Float(Sum);
      Expected: constant Float := Math.Log(1.0 + 1.0 / Float(D), Base => 10.0);
      Deviation: constant Float := abs(Expected-Actual);
   begin
      N_IO.Put(D, 5);
      N_IO.Put(Counted, 14);
      F_IO.Put(Float(Sum)*Expected, Fore => 16, Aft => 1, Exp => 0);
      F_IO.Put(100.0*Actual, Fore => 9, Aft => 2, Exp => 0);
      F_IO.Put(100.0*Expected, Fore => 11, Aft => 2, Exp => 0);
      F_IO.Put(100.0*Deviation, Fore => 13, Aft => 2, Exp => 0);
   end Print;

   Cnt: array(Nonzero_Digit) of Natural := (1 .. 9 => 0);
   D: Nonzero_Digit;
   Sum: Natural := 0;
   Counter: Positive;

begin
   while not Ada.Text_IO.End_Of_File loop
      -- each line in the input file holds Counter, followed by Fib(Counter)
      N_IO.Get(Counter);
        -- Counter and skip it, we just don't need it
      D := First_Digit(Ada.Text_IO.Get_Line);
        -- read the rest of the line and extract the first digit
      Cnt(D) := Cnt(D)+1;
      Sum := Sum + 1;
   end loop;
   Ada.Text_IO.Put_Line(" Digit  Found[total]   Expected[total]    Found[%]"
                                          & "   Expected[%]   Difference[%]");
   for I in Nonzero_Digit loop
      Print(I, Cnt(I), Sum);
      Ada.Text_IO.New_Line;
   end loop;
end Benford;
