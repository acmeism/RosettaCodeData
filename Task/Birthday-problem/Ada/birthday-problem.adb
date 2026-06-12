with Ada.Command_Line, Ada.Text_IO, Ada.Numerics.Discrete_random;

procedure Birthday_Test is

   Samples: constant Positive := Integer'Value(Ada.Command_Line.Argument(1));
   -- our experiment: Generate a X (birth-)days and check for Y-collisions
   -- the constant "Samples" is the number of repetitions of this experiment

   subtype Day is integer range 0 .. 365; -- this includes leap_days
   subtype Extended_Day is Integer range 0 .. 365*4; -- a four-year cycle
   package ANDR is new Ada.Numerics.Discrete_Random(Extended_Day);
   Random_Generator: ANDR.Generator;

   function Random_Day return Day is (ANDR.Random(Random_Generator) / 4);
   -- days 0 .. 364 are equally probable, leap-day 365 is 4* less probable

   type Checkpoint is record
      Multiplicity:  Positive;
      Person_Count:   Positive;
   end record;
   Checkpoints: constant array(Positive range <>) of Checkpoint
     := ( (2, 22),  (2, 23),  (3, 86),  (3, 87), (3, 88),
	  (4, 186), (4, 187), (5, 312), (5, 313), (5, 314) );
   type Result_Type is array(Checkpoints'Range) of Natural;
   Result: Result_Type := (others => 0);
   -- how often is a 2-collision in a group of 22 or 23, ..., a 5-collision
   -- in a group of 312 .. 314

   procedure Experiment(Result: in out Result_Type) is
   -- run the experiment once!
      A_Year: array(Day) of Natural := (others => 0);
      A_Day: Day;
      Multiplicity: Natural := 0;
      People: Positive := 1;
   begin
      for I in Checkpoints'Range loop
	 while People <= Checkpoints(I).Person_Count loop
	    A_Day := Random_Day;
	    A_Year(A_Day) := A_Year(A_Day)+1;
	    if A_Year(A_Day) > Multiplicity then
	       Multiplicity := Multiplicity + 1;
	    end if;
	    People := People + 1;
	 end loop;
	 if Multiplicity >= Checkpoints(I).Multiplicity then
	    Result(I) := Result(I) + 1;
            -- found a Multipl.-collision in a group of Person_Cnt.
	 end if;
      end loop;
   end Experiment;

   package TIO renames Ada.Text_IO;
   package FIO is new TIO.Float_IO(Float);

begin
    -- initialize the random generator
    ANDR.Reset(Random_Generator);

    -- repeat the experiment Samples times
    for I in 1 .. Samples loop
       Experiment(Result);
    end loop;

    -- print the results
    TIO.Put_Line("Birthday-Test with" & Integer'Image(Samples) & " samples:");
    for I in Result'Range loop
       FIO.Put(Float(Result(I))/Float(Samples), Fore => 3, Aft => 6, Exp => 0);
       TIO.Put_Line
	 ("% of groups with" & Integer'Image(Checkpoints(I).Person_Count) &
	  " have"            & Integer'Image(Checkpoints(I).Multiplicity) &
	  " persons sharing a common birthday.");
    end loop;
end Birthday_Test;
