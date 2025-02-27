##
function lookAndSay(): sequence of string;
begin
  var current: string := '1';
  yield current;

  while true do
  begin
    var ch := current[1];
    var count := 1;
    var next := '';
    foreach var i in 2..current.Length do
      if current[i] = ch then
        inc(count)
      else begin
        next += count.ToString + ch;
        ch := current[i];
        count := 1;
      end;
    current := next + count.ToString + ch;
    yield current;
  end;
end;

foreach var s in lookandsay.Take(12) do
  s.Println;
