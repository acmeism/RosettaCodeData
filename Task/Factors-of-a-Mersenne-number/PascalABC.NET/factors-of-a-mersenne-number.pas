const
  q = 929;

function isPrime(a: integer): boolean;
begin
  if a = 2 then
    begin result := true; exit end;
  if (a < 2) or (a mod 2 = 0) then
    begin result := false; exit end;
  for var i := 3 to sqrt(a).Floor step 2 do
    if a mod i = 0 then
      begin result := false; exit end;
  result := true;
end;

begin
  if not isPrime(q) then exit;
  var r := q;
  while r > 0 do r := r shl 1;
  var d := 2 * q + 1;
  while true do
  begin
    var i := 1;
    var p := r;
    while p <> 0 do
    begin
      i := (i * i) mod d;
      if p < 0 then i *= 2;
      if i > d then i -= d;
      p := p shl 1;
    end;
    if i <> 1 then d += 2 * q
    else break
  end;
  write('2^', q, ' - 1 = 0 (mod ', d, ')');
end.
