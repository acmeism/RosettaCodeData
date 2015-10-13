const long m = 2147483647L;
const long a = 48271L;
const long q = 44488L;
const long r = 3399L;
static long r_seed = 12345678L;

public static byte gen()
{
   long hi = r_seed / q;
   long lo = r_seed - q * hi;
   long t = a * lo - r * hi;
       if (t > 0)
           r_seed = t;
       else
           r_seed = t + m;
       return (byte)r_seed;
}

public static void ParkMiller(byte[] arr)
{
   byte[] arr = new byte[10900000];
    for (int i = 0; i < arr.Length; i++)
                {
                       arr[i] = gen();
                }
}
