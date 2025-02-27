uses System.Net, system.Globalization;

function digroot(n: integer): integer;
begin
  while n > 9 do
    n := n.ToString.Select(x -> x.ToDigit).Sum;
  result := n;
end;

begin
  var client := new WebClient();
  var text := client.DownloadString('http://wiki.puzzlers.org/pub/wordlists/unixdict.txt');
  var words: sequence of string := text.ToWords(|#10, #13|);
  words := words.Where(w -> w.length >= 4)
                .Where(w -> w.All(c -> c in 'abcdef'));

  var results := new List<(string, integer, integer)>;
  foreach var w in words do
  begin
    var wnum := integer.Parse(w, NumberStyles.HexNumber);
    results.Add((w, wnum, digroot(wnum)));
  end;

  println('Hex words in unixdict.txt:');
  println('Root  Word      Base 10');
  println('-' * 23);
  foreach var a in results.OrderBy(t -> t[2]) do
    writeln(a[2], a[0]:10, a[1]:11);
  println('Total count of these words:', results.Count);
  println;
  println('Hex words with > 3 distinct letters:');
  println('Root  Word      Base 10');
  println('-' * 23);
  results := results.Where(a -> (hset(a[0].ToCharArray).Count >= 4)).ToList;
  foreach var a in results.OrderByDescending(t -> t[1]) do
    writeln(a[2], a[0]:10, a[1]:11);
  println('Total count of those words:', results.Count)
end.
