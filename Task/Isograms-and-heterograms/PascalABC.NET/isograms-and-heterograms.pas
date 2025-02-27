uses System.Net;

function isogram(word: string): integer;
begin
  result := 0;
  var letters := new Dictionary<char, integer>;
  foreach var c in word do
    letters[c] := letters.Get(c) + 1;
  var counts: set of integer;
  foreach var letter in letters do
    counts += [letter.value];
  if counts.Count = 1 then
    result := letters.Get(word[1]);
end;

begin
  var client := new WebClient();
  var text := client.DownloadString('http://wiki.puzzlers.org/pub/wordlists/unixdict.txt');
  var words: sequence of string := text.ToWords(|#10, #13|);
  words.Where(w -> isogram(w) > 1)
       .OrderByDescending(w -> isogram(w))
       .ThenByDescending(w -> w.Length)
       .ThenBy(w -> w).println;
  println;
  words.where(w -> (isogram(w) = 1) and (w.Length > 10))
       .OrderByDescending(w -> w.Length)
       .ThenBy(w -> w).println;
end.
