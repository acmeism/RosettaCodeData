function AllSubSets<T>(a: array of T; i: integer; lst: List<T>): sequence of List<T>;
begin
  if i = a.Length then
  begin
    yield lst;
    exit;
  end;
  lst.Add(a[i]);
  yield sequence AllSubSets(a, i + 1, lst);
  lst.RemoveAt(lst.Count-1);
  yield sequence AllSubSets(a, i + 1, lst);
end;

begin
  AllSubSets(Arr(1..4),0,new List<integer>).Print;
end.
