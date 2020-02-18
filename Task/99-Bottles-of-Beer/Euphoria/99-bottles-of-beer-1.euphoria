constant
   bottles = "bottles",
   bottle = "bottle"

procedure beers (integer how_much)
   sequence word1 = bottles, word2 = bottles
   switch how_much do
   case 2 then
      word2 = bottle
   case 1 then
      word1 = bottle
      word2 = bottle
   end switch

   printf (1,
      "%d %s of beer on the wall \n" &
      "%d %s of beer \n" &
      "Take one down, and pass it around \n" &
      "%d %s of beer on the wall \n\n",
      { how_much, word1,
        how_much, word1,
        how_much-1, word2 }
   )
end procedure

for a = 99 to 1 by -1 do
   beers (a)
end for
