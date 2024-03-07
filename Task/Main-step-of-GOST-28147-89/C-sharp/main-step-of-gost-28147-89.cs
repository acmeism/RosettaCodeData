using System;

class Gost
{
    private byte[,] sBox = new byte[8, 16];
    private byte[] k87 = new byte[256];
    private byte[] k65 = new byte[256];
    private byte[] k43 = new byte[256];
    private byte[] k21 = new byte[256];
    private byte[] enc = new byte[8];

    public Gost(byte[,] s)
    {
        sBox = s;
        for (int i = 0; i < 256; i++)
        {
            k87[i] = (byte)((sBox[7, i >> 4] << 4) | sBox[6, i & 15]);
            k65[i] = (byte)((sBox[5, i >> 4] << 4) | sBox[4, i & 15]);
            k43[i] = (byte)((sBox[3, i >> 4] << 4) | sBox[2, i & 15]);
            k21[i] = (byte)((sBox[1, i >> 4] << 4) | sBox[0, i & 15]);
        }
    }

    private uint F(uint x)
    {
        x = (uint)(k87[x >> 24 & 255] << 24) | (uint)(k65[x >> 16 & 255] << 16) |
            (uint)(k43[x >> 8 & 255] << 8) | (uint)(k21[x & 255]);
        return x << 11 | x >> (32 - 11);
    }

    private static uint U32(byte[] b)
    {
        return (uint)(b[0] | b[1] << 8 | b[2] << 16 | b[3] << 24);
    }

    private static void B4(uint u, byte[] b)
    {
        b[0] = (byte)u;
        b[1] = (byte)(u >> 8);
        b[2] = (byte)(u >> 16);
        b[3] = (byte)(u >> 24);
    }

    public void MainStep(byte[] input, byte[] key)
    {
        uint key32 = U32(key);
        uint input1 = U32(input, 0);
        uint input2 = U32(input, 4);
        B4(F(key32 + input1) ^ input2, enc, 0);
        Array.Copy(input, 0, enc, 4, 4);
    }

    public byte[] Enc => enc;

    private static uint U32(byte[] b, int index)
    {
        return (uint)(b[index] | b[index + 1] << 8 | b[index + 2] << 16 | b[index + 3] << 24);
    }

    private static void B4(uint u, byte[] b, int index)
    {
        b[index] = (byte)u;
        b[index + 1] = (byte)(u >> 8);
        b[index + 2] = (byte)(u >> 16);
        b[index + 3] = (byte)(u >> 24);
    }
}

class Program
{
    static void Main(string[] args)
    {
        byte[,] cbrf = {
            {4, 10, 9, 2, 13, 8, 0, 14, 6, 11, 1, 12, 7, 15, 5, 3},
            {14, 11, 4, 12, 6, 13, 15, 10, 2, 3, 8, 1, 0, 7, 5, 9},
            {5, 8, 1, 13, 10, 3, 4, 2, 14, 15, 12, 7, 6, 0, 9, 11},
            {7, 13, 10, 1, 0, 8, 9, 15, 14, 4, 6, 12, 11, 2, 5, 3},
            {6, 12, 7, 1, 5, 15, 13, 8, 4, 10, 9, 14, 0, 3, 11, 2},
            {4, 11, 10, 0, 7, 2, 1, 13, 3, 6, 8, 5, 9, 12, 15, 14},
            {13, 11, 4, 1, 3, 15, 5, 9, 0, 10, 14, 7, 6, 8, 2, 12},
            {1, 15, 13, 0, 5, 7, 10, 4, 9, 2, 3, 14, 6, 11, 8, 12},
        };

        byte[] input = { 0x21, 0x04, 0x3B, 0x04, 0x30, 0x04, 0x32, 0x04 };
        byte[] key = { 0xF9, 0x04, 0xC1, 0xE2 };

        Gost g = new Gost(cbrf);
        g.MainStep(input, key);

        foreach (var b in g.Enc)
        {
            Console.Write("[{0:x2}]", b);
        }
        Console.WriteLine();
    }
}
