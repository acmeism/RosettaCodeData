var input = new[] { 1, 9, 2, 1, 3 };

foreach (var n in input)
	Task.Run(() =>
	{
		Thread.Sleep(n * 1000);
		Console.WriteLine(n);
	});
