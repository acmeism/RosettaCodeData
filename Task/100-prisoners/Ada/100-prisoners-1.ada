package Prisoners is

   type Win_Percentage is digits 2 range 0.0 .. 100.0;
   type Drawers is array (1 .. 100) of Positive;

   function Play_Game
     (Repetitions : in Positive;
      Strategy    :    not null access function
        (Cupboard     : in Drawers; Max_Prisoners : Integer;
         Max_Attempts :    Integer; Prisoner_Number : Integer) return Boolean)
      return Win_Percentage;
   -- Play the game with a specified number of repetitions, the chosen strategy
   -- is passed to this function

   function Optimal_Strategy
     (Cupboard : in Drawers; Max_Prisoners : Integer; Max_Attempts : Integer;
      Prisoner_Number :    Integer) return Boolean;

   function Random_Strategy
     (Cupboard : in Drawers; Max_Prisoners : Integer; Max_Attempts : Integer;
      Prisoner_Number :    Integer) return Boolean;

end Prisoners;
