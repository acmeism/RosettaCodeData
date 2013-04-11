import std.stdio;

bool isSelfDescribing2(long n) {
  if (n <= 0)
    return false;

  __gshared static uint[10] digits, d;
  digits[] = 0;
  d[] = 0;
  int i;
  if (n < uint.max) {
    uint nu = cast(uint)n;
    for (i = 0; nu > 0 && i < digits.length; nu /= 10, i++) {
      d[i] = cast(ubyte)(nu % 10);
      digits[d[i]]++;
    }
    if (nu > 0)
      return false;
  } else {
    for (i = 0; n > 0 && i < digits.length; n /= 10, i++) {
      d[i] = cast(ubyte)(n % 10);
      digits[d[i]]++;
    }
    if (n > 0)
      return false;
  }

  foreach (k; 0 .. i)
    if (d[k] != digits[i - k - 1])
      return false;
  return true;
}

void main() {
  foreach (x; [1210, 2020, 21200, 3211000,
               42101000, 521001000, 6210001000])
    assert(isSelfDescribing2(x));

  foreach (i; 0 .. 4_000_000)
    if (isSelfDescribing2(i))
      writeln(i);
}
