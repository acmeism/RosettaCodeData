bool isSelfDescribing2(ulong n) nothrow @nogc {
  if (n <= 0)
    return false;

  __gshared static uint[10] digits, d;
  digits[] = 0;
  d[] = 0;
  int i;

  if (n < uint.max) {
    uint nu = cast(uint)n;
    for (i = 0; nu > 0 && i < digits.length; nu /= 10, i++) {
      d[i] = nu % 10;
      digits[d[i]]++;
    }
    if (nu > 0)
      return false;
  } else {
    for (i = 0; n > 0 && i < digits.length; n /= 10, i++) {
      d[i] = n % 10;
      digits[d[i]]++;
    }
    if (n > 0)
      return false;
  }

  foreach (immutable k; 0 .. i)
    if (d[k] != digits[i - k - 1])
      return false;
  return true;
}

void main() {
  import std.stdio;

  foreach (immutable x; [1210, 2020, 21200, 3211000,
                         42101000, 521001000, 6210001000])
    assert(x.isSelfDescribing2);

  foreach (immutable i; 0 .. 4_000_000)
    if (i.isSelfDescribing2)
      i.writeln;
}
