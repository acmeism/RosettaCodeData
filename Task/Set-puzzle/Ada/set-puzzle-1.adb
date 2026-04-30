package Set_Puzzle is

   type Three is range 1..3;
   type Card is array(1 .. 4) of Three;
   type Cards is array(Positive range <>) of Card;
   type Set is array(Three) of Positive;

   procedure Deal_Cards(Dealt: out Cards);
   -- ouputs an array with disjoint cards

   function To_String(C: Card) return String;

   generic
      with procedure Do_something(C: Cards; S: Set);
   procedure Find_Sets(Given: Cards);
   -- calls Do_Something once for each set it finds.

end Set_Puzzle;
