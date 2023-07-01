with Ada.Numerics.Discrete_Random;

package body Set_Puzzle is

   package Rand is new Ada.Numerics.Discrete_Random(Three);
   R: Rand.Generator;

   function Locate(Some: Cards; C: Card) return Natural is
      -- returns index of card C in Some, or 0 if not found
   begin
      for I in Some'Range loop
	 if C = Some(I) then
	    return I;
	 end if;
      end loop;
      return 0;
   end Locate;

   procedure Deal_Cards(Dealt: out Cards) is
      function Random_Card return Card is
	 (Rand.Random(R), Rand.Random(R), Rand.Random(R), Rand.Random(R));
   begin
      for I in Dealt'Range loop
	 -- draw a random card until different from all card previously drawn
	 Dealt(I) := Random_Card; -- draw random card
	 while Locate(Dealt(Dealt'First .. I-1), Dealt(I)) /= 0 loop
	    -- Dealt(I) has been drawn before
	    Dealt(I) := Random_Card; -- draw another random card
	 end loop;
      end loop;
   end Deal_Cards;

   procedure Find_Sets(Given: Cards) is
      function To_Set(A, B: Card) return Card is
	 -- returns the unique card C, which would make a set with A and B
	 C: Card;
      begin
	 for I in 1 .. 4 loop
	    if A(I) = B(I) then
	       C(I) := A(I); -- all three the same
	    else
	       C(I) := 6 - A(I) - B(I); -- all three different;
	    end if;
	 end loop;
	 return C;
      end To_Set;

      X: Natural;

   begin
      for I in Given'Range loop
	 for J in Given'First .. I-1 loop
	    X := Locate(Given, To_Set(Given(I), Given(J)));
	    if I < X then -- X=0 is no set, 0 < X < I is a duplicate
	      Do_Something(Given, (J, I, X));
	    end if;
	 end loop;
      end loop;
   end Find_Sets;
	
   function To_String(C: Card) return String is

      Col: constant array(Three) of String(1..6)
	:= ("Red   ", "Green ", "Purple");
      Sym: constant array(Three) of String(1..8)
	:= ("Oval    ", "Squiggle", "Diamond ");
      Num: constant array(Three) of String(1..5)
	:= ("One  ", "Two  ", "Three");
      Sha: constant array(Three) of String(1..7)
	:= ("Solid  ", "Open   ", "Striped");

   begin
      return (Col(C(1)) & " " & Sym(C(2)) & " " & Num(C(3)) & " " & Sha(C(4)));
   end To_String;

begin
   Rand.Reset(R);
end Set_Puzzle;
