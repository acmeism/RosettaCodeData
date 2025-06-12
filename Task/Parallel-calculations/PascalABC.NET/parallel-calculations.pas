uses school;

const
  n = |12757923, 12878611, 12757923, 15808973, 15780709, 197622519|;

begin
  var j := 0;
  var m := 0;
  var l := new list<integer>[n.Length];
  {$omp parallel for}
  for var i := 0 to n.Length - 1 do
    l[i] := primefactors(n[i]);

  for var i := 0 to n.Length - 1 do
    if l[i].Min > m then
    begin
      m := l[i].Min;
      j := i;
    end;

  WriteLn('Number ', n[j], ' has largest minimal factor:');
  foreach var list in l[j] do
    Write(' ' + list);
end.
