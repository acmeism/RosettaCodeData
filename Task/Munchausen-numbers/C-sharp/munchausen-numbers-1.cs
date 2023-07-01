Func<char, int> toInt = c => c-'0';

foreach (var i in Enumerable.Range(1,5000)
	.Where(n => n == n.ToString()
		.Sum(x => Math.Pow(toInt(x), toInt(x)))))
	Console.WriteLine(i);
