with Ada.Text_IO, Ada.Command_Line, Ada.Numerics.Float_Random,
  Ada.Numerics.Generic_Elementary_Functions;

procedure Long_Basic_Stat is

   package FRG renames Ada.Numerics.Float_Random;
   package TIO renames Ada.Text_IO;

   type Counter is range 0 .. 2**63-1;
   type Result_Array is array(Natural range <>) of Counter;
   type High_Precision is digits 15;

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
   Val_Sum, Squ_Sum: High_Precision := 0.0;

begin
   FRG.Reset(Gen);
   for Outer in 1 .. 1000 loop
      for I in 1 .. N/1000 loop
         X := FRG.Random(Gen);
         Val_Sum   := Val_Sum + High_Precision(X);
         Squ_Sum := Squ_Sum + High_Precision(X)*High_Precision(X);
         declare
            Index: Integer := Integer(X*10.0);
         begin
            Results(Index) := Results(Index) + 1;
         end;
      end loop;
      if Outer mod 50 = 0 then
         TIO.New_Line(1);
         TIO.Put_Line(Integer'Image(Outer/10) &"% done; current results:");
         Put_Mean_Et_Al(Sample_Size => (Counter(Outer)*N)/1000,
                        Val_Sum     => Float(Val_Sum),
                        Square_Sum  => Float(Squ_Sum));
      else
         Ada.Text_IO.Put(".");
      end if;
   end loop;
   TIO.New_Line(4);
   TIO.Put_Line("After sampling" & Counter'Image(N) & " random numnbers: ");
   Put_Histogram(Results, Scale => 600, Full => N);
   TIO.New_Line;
   Put_Mean_Et_Al(Sample_Size => N,
                  Val_Sum => Float(Val_Sum), Square_Sum => Float(Squ_Sum));
end Long_Basic_Stat;
