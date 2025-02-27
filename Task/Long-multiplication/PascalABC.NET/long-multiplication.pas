function longmulti(a, b: string): string;
begin
  var i := 0;
  var j := 0;
  var k := false;

  // either is zero, return "0"
  if (a = '0') or (b = '0') then
  begin
    result := '0';
    exit;
  end;

  // see if either a or b is negative
  if a[1] = '-' then
  begin
    i := 2;
    k := not k;
  end;
  if b[1] = '-' then
  begin
    j := 2;
    k := not k;
  end;

  // if yes, prepend minus sign if needed and skip the sign
  if (i > 1) or (j > 1) then
  begin
    result := if k then '-' else '';
    result += longmulti(a[i:a.Length + 1], b[j:b.Length + 1]);
    exit;
  end;

  result := '0' * (a.length + b.length);

  for var ii := a.length downto 1 do
  begin
    var carry := 0;
    var kk := ii + b.length;
    for var jj := b.length downto 1 do
    begin
      var n := a[ii].todigit * b[jj].todigit + result[kk].todigit + carry;
      carry := n div 10;
      result[kk] := chr(n mod 10 + ord('0'));
      dec(kk);
    end;
    result[kk] := chr(ord(result[kk]) + carry);
  end;

  if result[1] = '0' then
    result[1:result.length] := result[2:result.length + 1];
end;

begin
  longmulti('-18446744073709551616', '-18446744073709551616').println;
end.
