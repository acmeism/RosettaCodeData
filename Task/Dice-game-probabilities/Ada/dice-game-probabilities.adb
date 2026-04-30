with Ada.Text_IO; use Ada.Text_IO;
with Ada.Numerics.Discrete_Random;

procedure Main is
   package real_io is new Float_IO (Long_Float);
   use real_io;

   type Dice is record
      Faces    : Positive;
      Num_Dice : Positive;
   end record;

   procedure Roll_Dice (The_Dice : in Dice; Count : out Natural) is
      subtype Faces is Integer range 1 .. The_Dice.Faces;
      package Die_Random is new Ada.Numerics.Discrete_Random (Faces);
      use Die_Random;
      Seed : Generator;
   begin
      Reset (Seed);
      Count := 0;
      for I in 1 .. The_Dice.Num_Dice loop
         Count := Count + Random (Seed);
      end loop;
   end Roll_Dice;

   function Win_Prob
     (Dice_1 : Dice; Dice_2 : Dice; Tries : Positive) return Long_Float
   is
      Count_1      : Natural := 0;
      Count_2      : Natural := 0;
      Count_1_Wins : Natural := 0;
   begin
      for I in 1 .. Tries loop
         Roll_Dice (Dice_1, Count_1);
         Roll_Dice (Dice_2, Count_2);
         if Count_1 > Count_2 then
            Count_1_Wins := Count_1_Wins + 1;
         end if;
      end loop;
      return Long_Float (Count_1_Wins) / Long_Float (Tries);
   end Win_Prob;

   D1 : Dice := (Faces => 4, Num_Dice => 9);
   D2 : Dice := (Faces => 6, Num_Dice => 6);
   D3 : Dice := (Faces => 10, Num_Dice => 5);
   D4 : Dice := (Faces => 7, Num_Dice => 6);

   P1 : Long_Float := Win_Prob (D1, D2, 1_000_000);
   P2 : Long_Float := Win_Prob (D3, D4, 1_000_000);
begin
   Put ("Dice D1 wins = ");
   Put (Item => P1, Fore => 1, Aft => 7, Exp => 0);
   New_Line;
   Put ("Dice D2 wins = ");
   Put (Item => P2, Fore => 1, Aft => 7, Exp => 0);
   New_Line;
end Main;
