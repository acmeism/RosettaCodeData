uses System.Net;

begin
  ServicePointManager.SecurityProtocol := SecurityProtocolType(3072);
  var wc := new WebClient;
  wc.Encoding := Encoding.UTF8;
  var s := wc.DownloadString('https://rosettacode.org/wiki/Special:Categories?limit=5000');
  s.Matches('([^><]+)</a>.+\(([\d,]+) member')
    .Select(x -> KV(x.Groups[1].Value,x.Groups[2].Value.Replace(',','').ToInteger))
    .Where(x -> not x.Key.StartsWith('Pages'))
    .OrderByDescending(pair -> pair.Value).Numerate.Take(10)
    .PrintLines(x -> $'Rank: {x[0],3} ({x[1].Value} entries)  {x[1].Key}')
end.
