import std.stdio, std.math, std.traits, std.typetuple;

const(T[N][]) permutationsFixed(T, size_t N)(in T[N] items)
pure nothrow {
  const(T[N])[] result;
  T[N] row;

  void perms(in T[] s, in T[] prefix=null) nothrow {
    if (s.length)
      foreach (immutable i, immutable c; s)
         perms(s[0 .. i] ~ s[i+1 .. $], prefix ~ c);
    else {
      row[] = prefix[];
      result ~= row;
    }
  }

  perms(items);
  return result;
}

enum Number : uint { One,      Two,     Three,  Four,       Five   }
enum Color  : uint { Red,      Green,   Blue,   White,      Yellow }
enum Drink  : uint { Milk,     Coffee,  Water,  Beer,       Tea    }
enum Smoke  : uint { PallMall, Dunhill, Blend,  BlueMaster, Prince }
enum Pet    : uint { Dog,      Cat,     Zebra,  Horse,      Bird   }
enum Nation : uint { British,  Swedish, Danish, Norvegian,  German }

bool isPossible(immutable(Number[5])* number,
                immutable(Color[5])* color=null,
                immutable(Drink[5])* drink=null,
                immutable(Smoke[5])* smoke=null,
                immutable(Pet[5])* pet=null
                ) pure nothrow {
  if ((number && (*number)[Nation.Norvegian] != Number.One) ||
      (color && (*color)[Nation.British] != Color.Red) ||
      (drink && (*drink)[Nation.Danish] != Drink.Tea) ||
      (smoke && (*smoke)[Nation.German] != Smoke.Prince) ||
      (pet && (*pet)[Nation.Swedish] != Pet.Dog))
    return false;

  if (!number || !color || !drink || !smoke || !pet)
    return true;

  foreach (immutable i; 0 .. 5) {
    if (((*color)[i] == Color.Green && (*drink)[i] != Drink.Coffee) ||
        ((*smoke)[i] == Smoke.PallMall && (*pet)[i] != Pet.Bird) ||
        ((*color)[i] == Color.Yellow && (*smoke)[i] != Smoke.Dunhill) ||
        ((*number)[i] == Number.Three && (*drink)[i] != Drink.Milk) ||
        ((*smoke)[i] == Smoke.BlueMaster && (*drink)[i] != Drink.Beer)||
        ((*color)[i] == Color.Blue && (*number)[i] != Number.Two))
      return false;

    foreach (immutable j; 0 .. 5) {
      if ((*color)[i] == Color.Green && (*color)[j] == Color.White &&
          (*number)[j] - (*number)[i] != 1)
        return false;

      immutable int diff = abs((*number)[i] - (*number)[j]);
      if (((*smoke)[i] == Smoke.Blend &&
           (*pet)[j] == Pet.Cat && diff != 1) ||
          ((*pet)[i] == Pet.Horse &&
           (*smoke)[j] == Smoke.Dunhill && diff != 1) ||
          ((*smoke)[i] == Smoke.Blend &&
           (*drink)[j] == Drink.Water && diff != 1))
        return false;
    }
  }

  return true;
}

void main() {
  static immutable perms = permutationsFixed!(uint, 5)([0,1,2,3,4]);
  // Not nice casts.
  static permsNumber = cast(immutable(Number[5][]))perms;
  static permsColor  = cast(immutable(Color[5][]))perms;
  static permsDrink  = cast(immutable(Drink[5][]))perms;
  static permsSmoke  = cast(immutable(Smoke[5][]))perms;
  static permsPet  = cast(immutable(Pet[5][]))perms;
  immutable nation = [EnumMembers!Nation];

  foreach (immutable ref number; permsNumber)
    if (isPossible(&number))
      foreach (immutable ref color; permsColor)
        if (isPossible(&number, &color))
          foreach (immutable ref drink; permsDrink)
            if (isPossible(&number, &color, &drink))
              foreach (immutable ref smoke; permsSmoke)
                if (isPossible(&number, &color, &drink, &smoke))
                  foreach (immutable ref pet; permsPet)
                    if (isPossible(&number,&color,&drink,&smoke,&pet)) {
                      writeln("Found a solution:");
                      foreach (x; TypeTuple!(nation, number, color,
                                             drink, smoke, pet))
                        writefln("%6s: %12s%12s%12s%12s%12s",
                                 (Unqual!(typeof(x[0]))).stringof,
                                 x[0], x[1], x[2], x[3], x[4]);
                      writeln();
                  }
}
