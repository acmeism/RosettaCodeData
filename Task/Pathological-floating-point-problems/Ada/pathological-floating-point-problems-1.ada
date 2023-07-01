with Ada.Text_IO;

procedure Converging_Sequence is

   generic
      type Num is digits <>;
      After: Positive;
   procedure Task_1;

   procedure Task_1 is
      package FIO is new Ada.Text_IO.Float_IO(Num);
      package IIO is new Ada.Text_IO.Integer_IO(Integer);

      procedure Output (I: Integer; N: Num) is
      begin
	 IIO.Put(Item => I, Width => 4);
	 FIO.Put(Item => N, Fore => 4, Aft =>  After, Exp => 0);
	 Ada.Text_IO.New_Line;
      end Output;

      Very_Old: Num :=  2.0;
      Old:      Num := -4.0;
      Now:        Num;
   begin
      Ada.Text_IO.Put_Line("Converging Sequence with" & Integer'Image(After) &
			     " digits");
      for I in 3 .. 100 loop
	 Now := 111.0  - 1130.0   /   Old   + 3000.0  /   (Old * Very_Old);
	 Very_Old := Old;
	 Old := Now;
	 if (I < 9) or else (I=20 or I=30 or I=50 or I=100) then
	    Output(I, Now);
	 end if;
      end loop;
      Ada.Text_IO.New_Line;
   end Task_1;

   type Short is digits(8);
   type Long  is digits(16);

   procedure Task_With_Short is new Task_1(Short, 8);
   procedure Task_With_Long  is new Task_1(Long, 16);
begin
   Task_With_Short;
   Task_With_Long;
end Converging_Sequence;
