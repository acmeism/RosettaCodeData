using System;

public class Gray {
    public static ulong grayEncode(ulong n) {
        return n^(n>>1);
    }

    public static ulong grayDecode(ulong n) {
        ulong i=1<<8*64-2; //long is 64-bit
        ulong p, b=p=n&i;

        while((i>>=1)>0)
            b|=p=n&i^p>>1;
        return b;
    }

    public static void Main(string[] args) {
        Console.WriteLine("Number\tBinary\tGray\tDecoded");
        for(ulong i=0;i<32;i++) {
            Console.WriteLine(string.Format("{0}\t{1}\t{2}\t{3}", i, Convert.ToString((long)i, 2), Convert.ToString((long)grayEncode(i), 2), grayDecode(grayEncode(i))));
        }
    }
}
