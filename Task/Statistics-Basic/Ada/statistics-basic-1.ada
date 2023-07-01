with Ada.Text_IO, Ada.Command_Line, Ada.Numerics.Float_Random,
  Ada.Numerics.Generic_Elementary_Functions;

procedure Basic_Stat is

   package FRG renames Ada.Numerics.Float_Random;
   package TIO renames Ada.Text_IO;

   type Counter is range 0 .. 2**31-1;
   type Result_Array is array(Natural range <>) of Counter;

   package FIO is new TIO.Float_IO(Float);

   procedure Put_Histogram(R: Result_Array; Scale, Full: Counter) is
   begin
      for I in R'Range loop
         FIO.Put(Float'Max(0.0, Float(I)/10.0 - 0.05),
                 Fore => 1, Aft => 2, Exp => 0);       TIO.Put("..");
         FIO.Put(Float'Min(1.0, Float(I)/10.0 + 0.05),
                 Fore => 1, Aft => 2, Exp => 0);       TIO.Put(": ");
         for J in 1 .. (R(I)* Scale)/Full loop
            Ada.Text_IO.Put("X");
         end loop;
         Ada.Text_IO.New_Line;
      end loop;
   end Put_Histogram;

   procedure Put_Mean_Et_Al(Sample_Size: Counter;
                            Val_Sum, Square_Sum: Float) is
      Mean: constant Float := Val_Sum / Float(Sample_Size);
      package Math is new Ada.Numerics.Generic_Elementary_Functions(Float);
   begin
      TIO.Put("Mean: ");
      FIO.Put(Mean,  Fore => 1, Aft => 5, Exp => 0);
      TIO.Put(",  Standard Deviation: ");
      FIO.Put(Math.Sqrt(abs(Square_Sum / Float(Sample_Size)
                           - (Mean * Mean))), Fore => 1, Aft => 5, Exp => 0);
      TIO.New_Line;
   end Put_Mean_Et_Al;

   N: Counter := Counter'Value(Ada.Command_Line.Argument(1));
   Gen: FRG.Generator;
   Results: Result_Array(0 .. 10) := (others => 0);
   X: Float;
   Val_Sum, Squ_Sum: Float := 0.0;

begin
   FRG.Reset(Gen);
   for I in 1 .. N loop
      X := FRG.Random(Gen);
      Val_Sum   := Val_Sum + X;
      Squ_Sum := Squ_Sum + X*X;
      declare
         Index: Integer := Integer(X*10.0);
      begin
         Results(Index) := Results(Index) + 1;
      end;
   end loop;
   TIO.Put_Line("After sampling" & Counter'Image(N) & " random numnbers: ");
   Put_Histogram(Results, Scale => 600, Full => N);
   TIO.New_Line;
   Put_Mean_Et_Al(Sample_Size => N, Val_Sum => Val_Sum, Square_Sum => Squ_Sum);
end Basic_Stat;
