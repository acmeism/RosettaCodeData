const maxcalc = 100000000;

var cache := new integer[maxcalc];

function Fusc(n: integer): integer;
begin
  if (n = 0) or (n = 1) then
  begin
    Result := n;
    exit
  end;
  if (n < maxcalc) and (cache[n] > 0) then
  begin
    Result := cache[n];
    exit;
  end;
  if n.IsEven then
    Result := Fusc(n div 2)
  else Result := Fusc((n-1) div 2) + Fusc((n+1) div 2);
  if n < maxcalc then
    cache[n] := Result
end;

function Digits(n: integer): integer;
begin
  Result := 0;
  while n > 0 do
  begin
    Result += 1;
    n := n div 10;
  end;
end;

begin
  (0..60).Select(Fusc).Println;
  var maxdigits := 1;
  var num := 0;
  var prevfun := 0;
  for var i:=1 to integer.MaxValue - 1 do
  begin
    var fun := Fusc(i);
    if fun > prevfun then
    begin
      var dig := Digits(fun);
      if dig > maxdigits then
      begin
        maxdigits := dig;
        Println(fun,i);
        num +=1;
        if num = 6 then exit;
      end;
    end;
    prevfun := fun;
  end;
end.
