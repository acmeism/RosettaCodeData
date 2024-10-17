uses System.Net;

function IsOrderedWord(w: string): boolean;
begin
  result := true;
  for var i := 2 to w.Length do
  begin
    if w[i] < w[i - 1] then result := false
  end;
end;

begin
  var client := new WebClient();
  var text := client.DownloadString('http://wiki.puzzlers.org/pub/wordlists/unixdict.txt');
  var words: sequence of string := text.ToWords(|#10, #13|);
  words := words.Where(x -> IsOrderedWord(x));
  var maxlen := words.Max(x -> x.Length);
  words.Where(x -> x.length = maxlen).Println;
end.
