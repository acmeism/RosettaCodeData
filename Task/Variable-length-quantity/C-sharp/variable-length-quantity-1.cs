namespace Vlq
{
  using System;
  using System.Collections.Generic;
  using System.Linq;

  public static class VarLenQuantity
  {
    public static ulong ToVlq(ulong integer)
    {
      var array = new byte[8];
      var buffer = ToVlqCollection(integer)
        .SkipWhile(b => b == 0)
        .Reverse()
        .ToArray();
      Array.Copy(buffer, array, buffer.Length);
      return BitConverter.ToUInt64(array, 0);
    }

    public static ulong FromVlq(ulong integer)
    {
      var collection = BitConverter.GetBytes(integer).Reverse();
      return FromVlqCollection(collection);
    }

    public static IEnumerable<byte> ToVlqCollection(ulong integer)
    {
      if (integer > Math.Pow(2, 56))
        throw new OverflowException("Integer exceeds max value.");

      var index = 7;
      var significantBitReached = false;
      var mask = 0x7fUL << (index * 7);
      while (index >= 0)
      {
        var buffer = (mask & integer);
        if (buffer > 0 || significantBitReached)
        {
          significantBitReached = true;
          buffer >>= index * 7;
          if (index > 0)
            buffer |= 0x80;
          yield return (byte)buffer;
        }
        mask >>= 7;
        index--;
      }
    }


    public static ulong FromVlqCollection(IEnumerable<byte> vlq)
    {
      ulong integer = 0;
      var significantBitReached = false;

      using (var enumerator = vlq.GetEnumerator())
      {
        int index = 0;
        while (enumerator.MoveNext())
        {
          var buffer = enumerator.Current;
          if (buffer > 0 || significantBitReached)
          {
            significantBitReached = true;
            integer <<= 7;
            integer |= (buffer & 0x7fUL);
          }

          if (++index == 8 || (significantBitReached && (buffer & 0x80) != 0x80))
            break;
        }
      }
      return integer;
    }

    public static void Main()
    {
      var integers = new ulong[] { 0x7fUL << 7 * 7, 0x80, 0x2000, 0x3FFF, 0x4000, 0x200000, 0x1fffff };

      foreach (var original in integers)
      {
        Console.WriteLine("Original: 0x{0:X}", original);

        //collection
        var seq = ToVlqCollection(original);
        Console.WriteLine("Sequence: 0x{0}", seq.Select(b => b.ToString("X2")).Aggregate(string.Concat));

        var decoded = FromVlqCollection(seq);
        Console.WriteLine("Decoded: 0x{0:X}", decoded);

        //ints
        var encoded = ToVlq(original);
        Console.WriteLine("Encoded: 0x{0:X}", encoded);

        decoded = FromVlq(encoded);
        Console.WriteLine("Decoded: 0x{0:X}", decoded);

        Console.WriteLine();
      }
      Console.WriteLine("Press any key to continue...");
      Console.ReadKey();
    }
  }
}
