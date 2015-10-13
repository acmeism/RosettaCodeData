using System;
using System.Security.Cryptography;

private static int GetRandomInt()
{
  int result = 0;
  var rng = new RNGCryptoServiceProvider();
  var buffer = new byte[4];

  rng.GetBytes(buffer);
  result = BitConverter.ToInt32(buffer, 0);

  return result;
}
