	var arrayOfBytes = Encoding.ASCII.GetBytes("The quick brown fox jumps over the lazy dog");

	var crc32 = new Crc32();
	Console.WriteLine(crc32.Get(arrayOfBytes).ToString("X"));
