void main() {
 import std.stdio, std.algorithm, permutations2;

 enum E { Red,      Green,   Blue,   White,      Yellow,
          Milk,     Coffee,  Water,  Beer,       Tea,
          PallMall, Dunhill, Blend,  BlueMaster, Prince,
          Dog,      Cat,     Zebra,  Horse,      Birds,
          British,  Swedish, Danish, Norvegian,  German }

 enum has =    (E[] a, E x,  E[] b, E y) => a.countUntil(x) == b.countUntil(y);
 enum leftOf = (E[] a, E x,  E[] b, E y) => a.countUntil(x) == b.countUntil(y) + 1;
 enum nextTo = (E[] a, E x,  E[] b, E y) => leftOf(a, x, b, y) || leftOf(b, y, a, x);

 with (E) foreach (houses; [Red, Blue, Green, Yellow, White].permutations)
  if (leftOf(houses, White, houses, Green))
   foreach (persons; [Norvegian, British, Swedish, German, Danish].permutations)
    if (has(persons, British, houses, Red) && persons[0] == Norvegian &&
        nextTo(persons, Norvegian, houses, Blue))
     foreach (drinks; [Tea, Coffee, Milk, Beer, Water].permutations)
      if (has(drinks, Tea, persons, Danish) &&
          has(drinks, Coffee, houses, Green) && drinks[$ / 2] == Milk)
       foreach (pets; [Dog, Birds, Cat, Horse, Zebra].permutations)
        if (has(pets, Dog, persons, Swedish))
         foreach (smokes; [PallMall, Dunhill, Blend, BlueMaster, Prince].permutations)
          if (has(smokes, PallMall, pets, Birds) &&
              has(smokes, Dunhill, houses, Yellow) &&
              nextTo(smokes, Blend, pets, Cat) &&
              nextTo(smokes, Dunhill, pets, Horse) &&
              has(smokes, BlueMaster, drinks, Beer) &&
              has(smokes, Prince, persons, German) &&
              nextTo(drinks, Water, smokes, Blend))
           writefln("%(%10s\n%)\n", [houses, persons, drinks, pets, smokes]);
}
