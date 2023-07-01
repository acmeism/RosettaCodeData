pragma Ada_2012;
with Ada.Numerics.Discrete_Random;
with Ada.Text_IO; use Ada.Text_IO;

package body Prisoners is

   subtype Drawer_Range is Positive range 1 .. 100;
   package Random_Drawer is new Ada.Numerics.Discrete_Random (Drawer_Range);
   use Random_Drawer;

   -- Helper procedures to initialise and shuffle the drawers

   procedure Swap (A, B : Positive; Cupboard : in out Drawers) is
      Temp : Positive;
   begin
      Temp         := Cupboard (B);
      Cupboard (B) := Cupboard (A);
      Cupboard (A) := Temp;
   end Swap;

   procedure Shuffle (Cupboard : in out Drawers) is
      G : Generator;
   begin
      Reset (G);
      for I in Cupboard'Range loop
         Swap (I, Random (G), Cupboard);
      end loop;
   end Shuffle;

   procedure Initialise_Drawers (Cupboard : in out Drawers) is
   begin
      for I in Cupboard'Range loop
         Cupboard (I) := I;
      end loop;
      Shuffle (Cupboard);
   end Initialise_Drawers;

   -- The two strategies for playing the game

   function Optimal_Strategy
     (Cupboard : in Drawers; Max_Prisoners : Integer; Max_Attempts : Integer;
      Prisoner_Number :    Integer) return Boolean
   is
      Current_Card : Positive;
   begin
      Current_Card := Cupboard (Prisoner_Number);
      if Current_Card = Prisoner_Number then
         return True;
      else
         for I in Integer range 1 .. Max_Attempts loop
            Current_Card := Cupboard (Current_Card);
            if Current_Card = Prisoner_Number then
               return True;
            end if;
         end loop;
      end if;
      return False;
   end Optimal_Strategy;

   function Random_Strategy
     (Cupboard : in Drawers; Max_Prisoners : Integer; Max_Attempts : Integer;
      Prisoner_Number :    Integer) return Boolean
   is
      Current_Card : Positive;
      G            : Generator;
   begin
      Reset (G);
      Current_Card := Cupboard (Prisoner_Number);
      if Current_Card = Prisoner_Number then
         return True;
      else
         for I in Integer range 1 .. Max_Attempts loop
            Current_Card := Cupboard (Random (G));
            if Current_Card = Prisoner_Number then
               return True;
            end if;
         end loop;
      end if;
      return False;
   end Random_Strategy;

   function Prisoners_Attempts
     (Cupboard : in Drawers; Max_Prisoners : Integer; Max_Attempts : Integer;
      Strategy :    not null access function
        (Cupboard     : in Drawers; Max_Prisoners : Integer;
         Max_Attempts :    Integer; Prisoner_Number : Integer) return Boolean)
      return Boolean
   is
   begin
      for Prisoner_Number in Integer range 1 .. Max_Prisoners loop
         if not Strategy
             (Cupboard, Max_Prisoners, Max_Attempts, Prisoner_Number)
         then
            return False;
         end if;
      end loop;
      return True;
   end Prisoners_Attempts;

   -- The function to play the game itself

   function Play_Game
     (Repetitions : in Positive;
      Strategy    :    not null access function
        (Cupboard     : in Drawers; Max_Prisoners : Integer;
         Max_Attempts :    Integer; Prisoner_Number : Integer) return Boolean)
      return Win_Percentage
   is
      Cupboard            : Drawers;
      Win, Game_Count     : Natural          := 0;
      Number_Of_Prisoners : constant Integer := 100;
      Max_Attempts        : constant Integer := 50;
   begin
      loop
         Initialise_Drawers (Cupboard);
         if Prisoners_Attempts
             (Cupboard     => Cupboard, Max_Prisoners => Number_Of_Prisoners,
              Max_Attempts => Max_Attempts, Strategy => Strategy)
         then
            Win := Win + 1;
         end if;
         Game_Count := Game_Count + 1;
         exit when Game_Count = Repetitions;
      end loop;
      return Win_Percentage ((Float (Win) / Float (Repetitions)) * 100.0);
   end Play_Game;

end Prisoners;
