bottles = 99;
while (bottles > 0)
  unit = (bottles == 1 ? "bottle" | "bottles");
  player:tell(bottles, " ", unit, " of beer on the wall.");
  player:tell(bottles, " ", unit, " of beer.");
  player:tell("Take one down, pass it around.");
  bottles = bottles - 1;
endwhile
player:tell("0 bottles of beer on the wall.");
