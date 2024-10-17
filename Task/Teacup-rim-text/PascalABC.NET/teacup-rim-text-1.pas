// Teacup rim text. Nigel Galloway: September 26th., 2024
##
function fG(n:string;g:integer):sequence of string;
begin
  yield n;
  foreach var i in 1..g-1 do begin
    n:=n.Cycle.Take(g+1).Skip(1).JoinIntoString;
    yield n;
  end;
end;
function fN(g:string):sequence of string;
begin
  foreach var n in System.IO.File.ReadLines(g) do if n.Length>2 then yield n;
end;
function fI(n:HashSet<string>;g:integer):sequence of sequence of string;
begin
  while n.Count>0 do begin
    var c:=fG(n.First,g);
    if (c.ElementAt(0)<>c.ElementAt(1)) and c.All(g->n.Contains(g)) then yield c;
    n:=n-c.ToHashSet;
  end;
end;

foreach var n in fN('unixdict.txt').GroupBy(n->n.length) do begin
  var g:= fI(n.ToHashSet,n.First.Length);
  if g.Count>0 then println(g);
end;
