static void Main()
{
  Console.WriteLine("Word size = {0} bytes,",sizeof(int));

  if (BitConverter.IsLittleEndian)
    Console.WriteLine("Little-endian.");
  else
    Console.WriteLine("Big-endian.");
}
