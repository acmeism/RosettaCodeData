void WriteSorted(string[] strings)
{
	var sorted = strings.OrderByDescending(x => x.Length);
	foreach(var s in sorted) Console.WriteLine($"{s.Length}: {s}");
}
WriteSorted(new string[] { "abcd", "123456789", "abcdef", "1234567" });
