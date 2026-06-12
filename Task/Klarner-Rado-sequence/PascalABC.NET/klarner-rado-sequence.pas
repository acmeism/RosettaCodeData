const
  Elements = 10_000_000;

type
  TKlarnerRado = array [1..Elements] of integer;

function initKlarnerRado(): TKlarnerRado;
begin
  var (i2, i3) := (1, 1);
  var (m2, m3) := (1, 1);
  for var i := 1 to result.count do
  begin
    var m := min(m2, m3);
    result[i] := m;
    if m2 = m then
    begin
      m2 := result[i2] shl 1 or 1;
      i2 += 1;
    end;
    if m3 = m then
    begin
      m3 := result[i3] * 3 + 1;
      i3 += 1;
    end;
  end;
end;

begin
  var klarnerRado := initKlarnerRado();

  println('First 100 elements of the Klarner-Rado sequence:');
  for var i := 1 to 100 do
    write(klarnerRado[i]:5, if i mod 10 = 0 then #10 else '');
  writeln;

  for var i := 3 to 7 do
    writeln('The ', 10 ** i, 'th element of Klarner-Rado sequence is ', klarnerrado[(10 ** i).Round]);
end.
