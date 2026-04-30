with Ada.Numerics.Discrete_Random;
with Ada.Text_IO; use Ada.Text_IO;

procedure Sleeping_Beauty is
   type Coin is (Heads, Tails);
   package Random_Coin is new Ada.Numerics.Discrete_Random (Coin); use Random_Coin;
   package FIO is new Float_IO (Float);
   Tosser : Generator;
   Probability : Float;

   function Experiment (Tosses : Integer) return Float is
      Awakenings, Heads_Count : Integer := 0;
   begin
      for Iteration in 1 .. Tosses loop
         case Random (Tosser) is
            when Heads =>
               Awakenings  := Awakenings + 1;
               Heads_Count := Heads_Count + 1;
            when Tails =>
               Awakenings := Awakenings + 2;
         end case;
      end loop;
      Put_Line ("Awakenings over" & Tosses'Image & " iterations:" & Awakenings'Image);
      return Float (Heads_Count) / Float (Awakenings) * 100.0;
   end Experiment;

begin
   Reset (Tosser);
   Probability := Experiment (1_000_000);
   Put ("Percentage probability of heads on waking:");
   FIO.Put (Probability, 3, 5, 0);
end Sleeping_Beauty;
