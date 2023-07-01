with Ada.Text_IO;

procedure Fractan is

   type Fraction is record Nom: Natural; Denom: Positive; end record;
   type Frac_Arr is array(Positive range <>) of Fraction;

   function "/" (N: Natural; D: Positive) return Fraction is
      Frac: Fraction := (Nom => N, Denom => D);
   begin
      return Frac;
   end "/";

   procedure F(List: Frac_Arr; Start: Positive; Max_Steps: Natural) is
      N: Positive := Start;
      J: Positive;
   begin
      Ada.Text_IO.Put(" 0:" & Integer'Image(N) & "   ");
      for I in 1 .. Max_Steps loop
	 J := List'First;
	 loop
	    if N mod List(J).Denom = 0 then
	       N := (N/List(J).Denom) * List(J).Nom;
	       exit; -- found fraction
	    elsif J >= List'Last then
	       return; -- did try out all fractions
	    else
	       J := J + 1; -- try the next fraction
	    end if;
	 end loop;
	 Ada.Text_IO.Put(Integer'Image(I) & ":" & Integer'Image(N) & "   ");
      end loop;
   end F;

begin
   -- F((2/3, 7/2, 1/5, 1/7, 1/9, 1/4, 1/8), 2, 100);
   -- output would be "0: 2    1: 7    2: 1" and then terminate

   F((17/91, 78/85, 19/51, 23/38, 29/33, 77/29, 95/23,
      77/19,  1/17, 11/13, 13/11, 15/14,  15/2, 55/1),
     2, 15);
   -- output is "0: 2    1: 15    2: 825    3: 725   ...   14: 132    15: 116"
end Fractan;
