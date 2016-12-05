public static void Main()
{
    var lookupTable = File.ReadLines("unixdict.txt").ToLookup(line => AnagramKey(line));
    var query = from a in lookupTable
        orderby a.Key.Length descending
        let deranged = FindDeranged(a)
        where deranged != null
        select deranged[0] + " " + deranged[1];
    Console.WriteLine(query.FirstOrDefault());
}
	
static string AnagramKey(string word) => new string(word.OrderBy(c => c).ToArray());
	
static string[] FindDeranged(IEnumerable<string> anagrams) => (
    from first in anagrams
    from second in anagrams
    where !second.Equals(first)
        && Enumerable.Range(0, first.Length).All(i => first[i] != second[i])
    select new [] { first, second })
    .FirstOrDefault();
