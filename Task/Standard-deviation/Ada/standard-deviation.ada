with Ada.Numerics.Elementary_Functions;  use Ada.Numerics.Elementary_Functions;
with Ada.Numerics.Elementary_Functions;  use Ada.Numerics.Elementary_Functions;
with Ada.Text_IO;                        use Ada.Text_IO;
with Ada.Float_Text_IO;                  use Ada.Float_Text_IO;
with Ada.Integer_Text_IO;                use Ada.Integer_Text_IO;

procedure Test_Deviation is
   type Sample is record
      N            : Natural := 0;
      Sum          : Float := 0.0;
      SumOfSquares : Float := 0.0;
   end record;
   procedure Add (Data : in out Sample; Point : Float) is
   begin
      Data.N       := Data.N + 1;
      Data.Sum    := Data.Sum    + Point;
      Data.SumOfSquares := Data.SumOfSquares + Point ** 2;
   end Add;
   function Deviation (Data : Sample) return Float is
   begin
      return Sqrt (Data.SumOfSquares / Float (Data.N) - (Data.Sum / Float (Data.N)) ** 2);
   end Deviation;

   Data : Sample;
   Test : array (1..8) of Integer := (2, 4, 4, 4, 5, 5, 7, 9);
begin
   for Index in Test'Range loop
      Add (Data, Float(Test(Index)));
      Put("N="); Put(Item => Index, Width => 1);
      Put(" ITEM="); Put(Item => Test(Index), Width => 1);
      Put(" AVG="); Put(Item => Float(Data.Sum)/Float(Index), Fore => 1, Aft => 3, Exp => 0);
      Put("  STDDEV="); Put(Item => Deviation (Data), Fore => 1, Aft => 3, Exp => 0);
      New_line;
   end loop;
end Test_Deviation;
