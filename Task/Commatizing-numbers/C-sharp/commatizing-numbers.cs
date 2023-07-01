static string[] inputs = {
	"pi=3.14159265358979323846264338327950288419716939937510582097494459231",
	"The author has two Z$100000000000000 Zimbabwe notes (100 trillion).",
	"\"-in Aus$+1411.8millions\"",
	"===US$0017440 millions=== (in 2000 dollars)"
};

void Main()
{
	inputs.Select(s => Commatize(s, 0, 3, ","))
              .ToList()
              .ForEach(Console.WriteLine);
}

string Commatize(string text, int startPosition, int interval, string separator)
{
	var matches = Regex.Matches(text.Substring(startPosition), "[0-9]*");
	var x = matches.Cast<Match>().Select(match => Commatize(match, interval, separator, text)).ToList();
	return string.Join("", x);
}


string Commatize(Match match, int interval, string separator, string original)
{
	if (match.Length <= interval)
		return original.Substring(match.Index,
                match.Index == original.Length ? 0 : Math.Max(match.Length, 1));
	
	return string.Join(separator, match.Value.Split(interval));
}

public static class Extension
{
	public static string[] Split(this string source, int interval)
	{
		return SplitImpl(source, interval).ToArray();
	}
	
	static IEnumerable<string>SplitImpl(string source, int interval)
	{
		for	(int i = 1; i < source.Length; i++)
		{
			if (i % interval != 0) continue;
			
			yield return source.Substring(i - interval, interval);
		}
	}
}
