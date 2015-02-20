import std.stdio, std.traits, std.algorithm, std.math;

enum Content { Beer, Coffee, Milk, Tea, Water,
               Danish, English, German, Norwegian, Swedish,
               Blue, Green, Red, White, Yellow,
               Blend, BlueMaster, Dunhill, PallMall, Prince,
               Bird, Cat, Dog, Horse, Zebra }
enum Test { Drink, Person, Color, Smoke, Pet }
enum House { One, Two, Three, Four, Five }

alias TM = Content[EnumMembers!Test.length][EnumMembers!House.length];

bool finalChecks(in ref TM M) pure nothrow @safe @nogc {
  int diff(in Content a, in Content b, in Test ca, in Test cb)
  nothrow @safe @nogc {
    foreach (immutable h1; EnumMembers!House)
      foreach (immutable h2; EnumMembers!House)
        if (M[ca][h1] == a && M[cb][h2] == b)
          return h1 - h2;
    assert(0); // Useless but required.
  }

  with (Content) with (Test)
    return abs(diff(Norwegian, Blue, Person, Color)) == 1 &&
           diff(Green, White, Color, Color) == -1 &&
           abs(diff(Horse, Dunhill, Pet, Smoke)) == 1 &&
           abs(diff(Water, Blend, Drink, Smoke)) == 1 &&
           abs(diff(Blend, Cat, Smoke, Pet)) == 1;
}

bool constrained(in ref TM M, in Test atest) pure nothrow @safe @nogc {
  with (Content) with (Test) with (House)
    final switch (atest) {
      case Drink:
        return M[Drink][Three] == Milk;
      case Person:
        foreach (immutable h; EnumMembers!House)
          if ((M[Person][h] == Norwegian && h != One) ||
              (M[Person][h] == Danish && M[Drink][h] != Tea))
            return false;
        return true;
      case Color:
        foreach (immutable h; EnumMembers!House)
          if ((M[Person][h] == English && M[Color][h] != Red) ||
              (M[Drink][h] == Coffee && M[Color][h] != Green))
            return false;
        return true;
      case Smoke:
        foreach (immutable h; EnumMembers!House)
          if ((M[Color][h] == Yellow && M[Smoke][h] != Dunhill) ||
              (M[Smoke][h] == BlueMaster && M[Drink][h] != Beer) ||
              (M[Person][h] == German && M[Smoke][h] != Prince))
            return false;
        return true;
      case Pet:
        foreach (immutable h; EnumMembers!House)
          if ((M[Person][h] == Swedish && M[Pet][h] != Dog) ||
              (M[Smoke][h] == PallMall && M[Pet][h] != Bird))
            return false;
        return finalChecks(M);
    }
}

void show(in ref TM M) {
  foreach (h; EnumMembers!House) {
    writef("%5s: ", h);
    foreach (immutable t; EnumMembers!Test)
      writef("%10s ", M[t][h]);
    writeln;
  }
}

void solve(ref TM M, in Test t, in size_t n) {
  if (n == 1 && constrained(M, t)) {
    if (t < 4) {
      solve(M, [EnumMembers!Test][t + 1], 5);
    } else {
      show(M);
      return;
    }
  }
  foreach (immutable i; 0 .. n) {
    solve(M, t, n - 1);
    swap(M[t][n % 2 ? 0 : i], M[t][n - 1]);
  }
}

void main() {
  TM M;
  foreach (immutable t; EnumMembers!Test)
    foreach (immutable h; EnumMembers!House)
      M[t][h] = EnumMembers!Content[t * 5 + h];

  solve(M, Test.Drink, 5);
}
