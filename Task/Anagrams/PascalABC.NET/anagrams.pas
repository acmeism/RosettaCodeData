begin
  var s := System.Net.WebClient.Create.DownloadString('http://wiki.puzzlers.org/pub/wordlists/unixdict.txt');
  var words := s.Split;
  var groups := words.GroupBy(word -> word.Order.JoinToString);
  var maxCount := groups.Max(gr -> gr.Count);
  groups.Where(gr -> gr.Count = maxCount).PrintLines;
end.
