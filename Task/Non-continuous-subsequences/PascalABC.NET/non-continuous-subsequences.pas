function AllSubSets<T>(a: List<T>; i: integer; lst: List<T>): sequence of List<T>;
begin
  if i = a.Count then yield lst
  else
  begin
    lst.Add(a[i]);
    yield sequence AllSubSets(a, i + 1, lst);
    lst.RemoveAt(lst.Count - 1);
    yield sequence AllSubSets(a, i + 1, lst);
  end;
end;

function IsContinuous(lst: List<integer>) :=
if lst.Count > 0 then lst[^1] - lst[0] + 1 = lst.Count else true;

function ncsub<T>(seq: list<T>) :=
Allsubsets(Lst(1..seq.Count), 0, new List<integer>)
                                   .Where(s -> not iscontinuous(s))
                                   .Select(s -> s.Select(i -> seq[i - 1]).ToList);

begin
  var seq := |'C', 'D', 'A', 'E', 'B'|.ToList;
  println('Non-continuous subsequences for', seq, ':');
  ncsub(seq).Println;
  println;
  println('Non-continuous subsequences:');
  for var n := 1 to 20 do
    println([1..n], '=', ncsub([1..n].ToList).Count);
end.
