with Ada.Numerics.Discrete_Random;
package body Pig is

   function Score(P: Player) return Natural is (P.Score);
   function All_Recent(P: Player) return Natural is (P.All_Recent);
   function Recent(P: Player) return Natural is (Natural(P.Recent_Roll));
   function Has_Won(P: Player) return Boolean is (P.Score >= 100);

   package RND is new Ada.Numerics.Discrete_Random(Dice_Score);
   Gen: RND.Generator;

   procedure Roll(P: in out Player) is
   begin
      P.Recent_Roll := RND.Random(Gen);
      if P.Recent = 1 then
	 P.All_Recent := 0;
      else
	 P.All_Recent := P.All_Recent + P.Recent;
      end if;
   end Roll;

   procedure Add_To_Score(P: in out Player) is
   begin
      P.Score := P.Score + P.All_Recent;
      P.All_Recent := 0;
   end Add_To_Score;

   procedure Play(First, Second: Actor'Class;
		  First_Wins: out Boolean) is
      P1, P2: Player;
   begin
      loop
	 Roll(P1);
	 while First.Roll_More(P1, P2) and then P1.Recent > 1 loop
	    Roll(P1);
	 end loop;
	 Add_To_Score(P1);
	 exit when P1.Score >= 100;
	 Roll(P2);
	 while Second.Roll_More(P2, P1) and then P2.Recent > 1 loop
	    Roll(P2);
	 end loop;
	 Add_To_Score(P2);
	 exit when P2.Score >= 100;
      end loop;
      First_Wins := P1.Score >= 100;
   end Play;

begin
   RND.Reset(Gen);
end Pig;
