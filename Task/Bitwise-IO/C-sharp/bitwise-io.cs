using System;
using System.IO;

public class BitReader
{
    uint readData = 0;
    int startPosition = 0;
    int endPosition = 0;

    public int InBuffer
    {
        get { return endPosition - startPosition; }
    }

    private Stream stream;

    public Stream BaseStream
    {
        get { return stream; }
    }

    public BitReader(Stream stream)
    {
        this.stream = stream;
    }

    void EnsureData(int bitCount)
    {
        int readBits = bitCount - InBuffer;
        while (readBits > 0)
        {
            int b = BaseStream.ReadByte();

            if (b < 0) throw new InvalidOperationException("Unexpected end of stream");

            readData |= checked((uint)b << endPosition);
            endPosition += 8;
            readBits -= 8;
        }
    }

    public bool ReadBit()
    {
        return Read(1) > 0;
    }

    public int Read(int bitCount)
    {
        EnsureData(bitCount);

        int result = (int)(readData >> startPosition) & ((1 << bitCount) - 1);
        startPosition += bitCount;
        if (endPosition == startPosition)
        {
            endPosition = startPosition = 0;
            readData = 0;
        }
        else if (startPosition >= 8)
        {
            readData >>= startPosition;
            endPosition -= startPosition;
            startPosition = 0;
        }

        return result;
    }

    public void Align()
    {
        endPosition = startPosition = 0;
        readData = 0;
    }
}

public class BitWriter
{
    uint data = 0;
    int dataLength = 0;
    Stream stream;

    public Stream BaseStream
    {
        get { return stream; }
    }

    public int BitsToAligment
    {
        get { return (32 - dataLength) % 8; }
    }

    public BitWriter(Stream stream)
    {
        this.stream = stream;
    }

    public void WriteBit(bool value)
    {
        Write(value ? 1 : 0, 1);
    }

    public void Write(int value, int length)
    {
        uint currentData = data | checked((uint)value << dataLength);
        int currentLength = dataLength + length;
        while (currentLength >= 8)
        {
            BaseStream.WriteByte((byte)currentData);
            currentData >>= 8;
            currentLength -= 8;
        }
        data = currentData;
        dataLength = currentLength;
    }

    public void Align()
    {
        if (dataLength > 0)
        {
            BaseStream.WriteByte((byte)data);

            data = 0;
            dataLength = 0;
        }
    }
}

class Program
{
    static void Main(string[] args)
    {
        MemoryStream ms = new MemoryStream();
        BitWriter writer = new BitWriter(ms);
        writer.WriteBit(true);
        writer.Write(5, 3);
        writer.Write(0x0155, 11);
        writer.Align();

        ms.Position = 0;
        BitReader reader = new BitReader(ms);
        Console.WriteLine(reader.ReadBit());
        Console.WriteLine(reader.Read(3));
        Console.WriteLine(reader.Read(11).ToString("x4"));
        reader.Align();
    }
}
