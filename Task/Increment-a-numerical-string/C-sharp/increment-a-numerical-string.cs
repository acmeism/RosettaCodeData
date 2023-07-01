string s = "12345";
s = (int.Parse(s) + 1).ToString();
// The above functions properly for strings >= Int32.MinValue and
//  < Int32.MaxValue. ( -2147483648 to 2147483646 )

// The following will work for any arbitrary-length integer string.
//  (Assuming that the string fits in memory, leaving enough space
//  for the temporary BigInteger created, plus the resulting string):
using System.Numerics;
string bis = "123456789012345678999999999";
bis = (BigInteger.Parse(bis) + 1).ToString();
// Note that extremely long strings will take a long time to parse
//  and convert from a BigInteger back into a string.
