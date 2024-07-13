procedure RemoveLines(fname: string; start: integer; count: integer := 1);
begin
  WriteAllLines(fname,
    ReadAllLines(fname).Where((s,ind) -> ind not in start - 1 .. start + count - 2).ToArray)
end;

begin
  RemoveLines('a2.pas',3,2);
end.
