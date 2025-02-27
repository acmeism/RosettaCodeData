function digits(n: integer): sequence of integer;
begin
  result := new List<integer>;
  repeat
    result := result + n mod 10;
    n := n div 10;
  until n = 0;
end;

function gen(n: integer): integer;
begin
  result := n;
  while (result <> 1) and (result <> 89) do
  begin
    var s := 0;
    foreach var d in digits(result) do s += d * d;
    result := s;
  end;
end;

function chainsEndingWith89(ndigits: integer): int64;
begin
  var prevcount := new Dictionary<integer, int64>;
  var currcount := new Dictionary<integer, int64>;
  for var i := 0 to 9 do prevcount[i * i] := 1;

  loop ndigits - 1 do
  begin
    currcount.Clear;
    foreach var prev in prevcount do
      for var newdigit := 0 to 9 do
      begin
        var nextgen := newdigit * newdigit + prev.key;
        currcount[nextgen] := currcount.get(nextgen) + prev.value;
      end;
    prevcount := new Dictionary<integer, int64>(currcount);
  end;

  foreach var curr in currcount do
    if (curr.key <> 0) and (gen(curr.key) = 89) then
      result += curr.value;
end;

begin
  println('For  8 digits: ', chainsEndingWith89(8));
  println('For 18 digits: ', chainsEndingWith89(18));
  println(milliseconds, 'ms');
end.
