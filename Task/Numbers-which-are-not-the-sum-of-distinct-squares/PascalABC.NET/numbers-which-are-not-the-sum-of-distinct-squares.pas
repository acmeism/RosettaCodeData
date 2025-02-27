function soms(n: integer; f: list<integer>): boolean;
begin
  if (n <= 0) then result := false
  else
  if n in f then result := true
  else
    case n.CompareTo(f.Sum) of
      1: result := false;
      0: result := true;
    else
      var rf := f[::-1].Skip(1).ToList;
      result := soms(n - f.Last, rf) or soms(n, rf);
    end;
end;

begin
  var i := 1;
  var g := 1;
  var s := new List<integer>;
  var a := new List<integer>;

  repeat
    if i.Sqrt.Floor.Sqr = i then s.Add(i);
    if not soms(i, s) then
    begin
      g := i;
      a.Add(g)
    end;
    i += 1;
  until g < (i shr 1);

  println('Numbers which are not the sum of distinct squares:');
  a.println;
  println;
  println('Stopped checking after finding', i - g, 'sequential non-gaps after the final gap of', g);
  println('Found', a.count, 'total.');
end.
