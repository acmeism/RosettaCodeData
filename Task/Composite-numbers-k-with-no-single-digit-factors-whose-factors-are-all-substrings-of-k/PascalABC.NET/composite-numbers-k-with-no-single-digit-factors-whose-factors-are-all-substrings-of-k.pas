function Factors(n: integer): List<integer>;
begin
  var lst := new List<integer>;
  if n = 1 then  lst.Add(n);
  var i := 2;
  while i * i <= n  do
  begin
    while n mod i = 0 do
    begin
      lst.Add(i);
      n := n div i;
    end;
    i += 1;
  end;
  if n >= 2 then lst.Add(n);
  Result := lst;
end;

function composite(): sequence of integer;
begin
  var n := 11;
  while true do
  begin
    if (n mod 3 <> 0) and (n mod 5 <> 0) and (n mod 7 <> 0) then
      for var i := 11 to n.Sqrt.floor step 2 do
        if n mod i = 0 then
        begin
          yield n;
          break;
        end;
    n += 2;
  end;
end;

function allprimesubstr(n: integer): boolean;
begin
  result := true;
  foreach var i in factors(n) do
    if not n.tostring.contains(i.tostring) then
    begin
      result := false;
      break;
    end;
end;

begin
  composite.where(x -> allprimesubstr(x)).take(20).Println;
  Println('Seconds:',milliseconds/1000);
end.
