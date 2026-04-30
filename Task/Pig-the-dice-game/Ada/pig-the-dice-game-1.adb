package Pig is

   type Dice_Score is range 1 .. 6;

   type Player is tagged private;
   function Recent(P: Player) return Natural;
   function All_Recent(P: Player) return Natural;
   function Score(P: Player) return Natural;

   type Actor is abstract tagged null record;
   function Roll_More(A: Actor; Self, Opponent: Player'Class)
		     return Boolean is abstract;

   procedure Play(First, Second: Actor'Class; First_Wins: out Boolean);

private
   type Player is tagged record
      Score: Natural := 0;
      All_Recent: Natural := 0;
      Recent_Roll: Dice_Score := 1;
   end record;

end Pig;
