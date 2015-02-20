import std.stdio, std.math, std.traits, std.typecons, std.typetuple, permutations1;

uint factorial(in uint n) pure nothrow @nogc @safe
in {
    assert(n <= 12);
} body {
    uint result = 1;
    foreach (immutable i; 1 .. n + 1)
        result *= i;
    return result;
}

enum Number { One,      Two,     Three,  Four,       Five   }
enum Color  { Red,      Green,   Blue,   White,      Yellow }
enum Drink  { Milk,     Coffee,  Water,  Beer,       Tea    }
enum Smoke  { PallMall, Dunhill, Blend,  BlueMaster, Prince }
enum Pet    { Dog,      Cat,     Zebra,  Horse,      Bird   }
enum Nation { British,  Swedish, Danish, Norvegian,  German }

enum size_t M = EnumMembers!Number.length;

auto nullableRef(T)(ref T item) pure nothrow @nogc {
    return NullableRef!T(&item);
}

bool isPossible(NullableRef!(immutable Number[M]) number,
                NullableRef!(immutable Color[M])  color=null,
                NullableRef!(immutable Drink[M])  drink=null,
                NullableRef!(immutable Smoke[M])  smoke=null,
                NullableRef!(immutable Pet[M])    pet=null) pure nothrow @safe @nogc {
  if ((!number.isNull && number[Nation.Norvegian] != Number.One) ||
      (!color.isNull  && color[Nation.British]    != Color.Red) ||
      (!drink.isNull  && drink[Nation.Danish]     != Drink.Tea) ||
      (!smoke.isNull  && smoke[Nation.German]     != Smoke.Prince) ||
      (!pet.isNull    && pet[Nation.Swedish]      != Pet.Dog))
    return false;

  if (number.isNull || color.isNull || drink.isNull || smoke.isNull ||
      pet.isNull)
    return true;

  foreach (immutable i; 0 .. M) {
    if ((color[i]  == Color.Green      && drink[i]  != Drink.Coffee) ||
        (smoke[i]  == Smoke.PallMall   && pet[i]    != Pet.Bird) ||
        (color[i]  == Color.Yellow     && smoke[i]  != Smoke.Dunhill) ||
        (number[i] == Number.Three     && drink[i]  != Drink.Milk) ||
        (smoke[i]  == Smoke.BlueMaster && drink[i]  != Drink.Beer)||
        (color[i]  == Color.Blue       && number[i] != Number.Two))
      return false;

    foreach (immutable j; 0 .. M) {
      if (color[i] == Color.Green && color[j] == Color.White &&
          number[j] - number[i] != 1)
        return false;

      immutable diff = abs(number[i] - number[j]);
      if ((smoke[i] == Smoke.Blend && pet[j]   == Pet.Cat       && diff != 1) ||
          (pet[i]   == Pet.Horse   && smoke[j] == Smoke.Dunhill && diff != 1) ||
          (smoke[i] == Smoke.Blend && drink[j] == Drink.Water   && diff != 1))
        return false;
    }
  }

  return true;
}

alias N = nullableRef; // At module level scope to be used with UFCS.

void main() {
  enum size_t FM = M.factorial;

  static immutable Number[M][FM] numberPerms = [EnumMembers!Number].permutations;
  static immutable Color[M][FM]  colorPerms =  [EnumMembers!Color].permutations;
  static immutable Drink[M][FM]  drinkPerms =  [EnumMembers!Drink].permutations;
  static immutable Smoke[M][FM]  smokePerms =  [EnumMembers!Smoke].permutations;
  static immutable Pet[M][FM]    petPerms =    [EnumMembers!Pet].permutations;

  // You can reduce the compile-time computations using four casts like this:
  // static colorPerms = cast(immutable Color[M][FM])numberPerms;

  static immutable Nation[M] nation = [EnumMembers!Nation];

  foreach (immutable ref number; numberPerms)
    if (isPossible(number.N))
      foreach (immutable ref color; colorPerms)
        if (isPossible(number.N, color.N))
          foreach (immutable ref drink; drinkPerms)
            if (isPossible(number.N, color.N, drink.N))
              foreach (immutable ref smoke; smokePerms)
                if (isPossible(number.N, color.N, drink.N, smoke.N))
                  foreach (immutable ref pet; petPerms)
                    if (isPossible(number.N, color.N, drink.N, smoke.N, pet.N)) {
                      writeln("Found a solution:");
                      foreach (x; TypeTuple!(nation, number, color, drink, smoke, pet))
                        writefln("%6s: %12s%12s%12s%12s%12s",
                                 (Unqual!(typeof(x[0]))).stringof,
                                 x[0], x[1], x[2], x[3], x[4]);
                      writeln;
                  }
}
