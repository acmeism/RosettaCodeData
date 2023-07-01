package Preferences
is

   type Guy_X is (no_guy, abe, bob, col, dan, ed, fred, gav, hal, ian, jon);
   subtype Guy is Guy_X range Guy_X'Succ(Guy_X'First) .. Guy_X'Last;

   type Girl_X is (no_girl, abi, bea, cath, dee, eve, fay, gay, hope, ivy, jan);
   subtype Girl is Girl_X range Girl_X'Succ(Girl_X'First) .. Girl_X'Last;

   type Extended_Rank is range 0 .. 10;
   subtype Rank is Extended_Rank range 1 .. Extended_Rank'Last;

   type His_Rank is array (Rank) of Girl;
   type He_Prefers is array (Guy) of His_Rank;

   Guys_Like : constant He_Prefers := He_Prefers'(
     abe  => His_Rank'(abi, eve, cath, ivy, jan, dee, fay, bea, hope, gay),
     bob  => His_Rank'(cath, hope, abi, dee, eve, fay, bea, jan, ivy, gay),
     col  => His_Rank'(hope, eve, abi, dee, bea, fay, ivy, gay, cath, jan),
     dan  => His_Rank'(ivy, fay, dee, gay, hope, eve, jan, bea, cath, abi),
     ed   => His_Rank'(jan, dee, bea, cath, fay, eve, abi, ivy, hope, gay),
     fred => His_Rank'(bea, abi, dee, gay, eve, ivy, cath, jan, hope, fay),
     gav  => His_Rank'(gay, eve, ivy, bea, cath, abi, dee, hope, jan, fay),
     hal  => His_Rank'(abi, eve, hope, fay, ivy, cath, jan, bea, gay, dee),
     ian  => His_Rank'(hope, cath, dee, gay, bea, abi, fay, ivy, jan, eve),
     jon  => His_Rank'(abi, fay, jan, gay, eve, bea, dee, cath, ivy, hope));

   type Her_Rank is array(Rank) of Guy;
   type She_Prefers is array (Girl) of Her_Rank;

   Girls_Like : constant She_Prefers := She_Prefers'(
     abi  => Her_Rank'(bob, fred, jon, gav, ian, abe, dan, ed, col, hal),
     bea  => Her_Rank'(bob, abe, col, fred, gav, dan, ian, ed, jon, hal),
     cath => Her_Rank'(fred, bob, ed, gav, hal, col, ian, abe, dan, jon),
     dee  => Her_Rank'(fred, jon, col, abe, ian, hal, gav, dan, bob, ed),
     eve  => Her_Rank'(jon, hal, fred, dan, abe, gav, col, ed, ian, bob),
     fay  => Her_Rank'(bob, abe, ed, ian, jon, dan, fred, gav, col, hal),
     gay  => Her_Rank'(jon, gav, hal, fred, bob, abe, col, ed, dan, ian),
     hope => Her_Rank'(gav, jon, bob, abe, ian, dan, hal, ed, col, fred),
     ivy  => Her_Rank'(ian, col, hal, gav, fred, bob, abe, ed, jon, dan),
     jan  => Her_Rank'(ed, hal, gav, abe, bob, jon, col, ian, fred, dan));

end Preferences;
