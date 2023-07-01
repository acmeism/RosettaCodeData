with Ada.Text_IO, Ada.Numerics;

procedure Chaotic_Bank is

   generic
     type Num is digits <>;
     After: Positive;
   procedure Task_2;

   procedure Task_2 is
      package IIO is new Ada.Text_IO.Integer_IO(Integer);
      package FIO is new Ada.Text_IO.Float_IO(Num);
      Balance: Num :=  Ada.Numerics.E - 1.0;
   begin
      Ada.Text_IO.Put_Line("Chaotic Bank Society with" &
			     Integer'Image(After) & " digits");
      Ada.Text_IO.Put_Line("year        balance");
      for year in 1 .. 25 loop
	 Balance := (Balance * Num(year))- 1.0;
	 IIO.Put(Item => Year, Width => 2);
	 FIO.Put(Balance, Fore => 11, Aft => After, Exp => 0);
	 Ada.Text_IO.New_Line;
      end loop;
      Ada.Text_IO.New_Line;
   end Task_2;

   type Short is digits(8);
   type Long  is digits(16);

   procedure Task_With_Short is new Task_2(Short, 8);
   procedure Task_With_Long  is new Task_2(Long, 16);

begin
   Task_With_Short;
   Task_With_Long;
end Chaotic_Bank;
