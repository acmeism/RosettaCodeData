program with_multiple_ranges;

{$APPTYPE CONSOLE}

uses
  System.SysUtils;

var
  prod: Int64 = 1;
  sum: Int64 = 0;

function labs(value: Int64): Int64;
begin
  Result := value;
  if value < 0 then
    Result := -Result;
end;

procedure process(j: Int64);
begin
  sum := sum + (abs(j));
  if (labs(prod) < (1 shl 27)) and (j <> 0) then
    prod := prod * j;
end;

function ipow(n: Integer; e: Cardinal): Int64;
var
  pr: Int64;
  max, i: Cardinal;
begin
  result := n;
  if e = 0 then
    Exit(1);
  max := e;
  for i := 2 to max do
    result := result * n;
end;

var
  j: Int64;
  p: Int64;

const
  x = 5;
  y = -5;
  z = -2;
  one = 1;
  three = 3;
  seven = 7;

begin
  p := ipow(11, x);

  j := -three;
  while j <= ipow(3, 3) do
  begin
    process(j);
    inc(j, three);
  end;

  j := -seven;
  while j <= seven do
  begin
    process(j);
    inc(j, x);
  end;

  j := 555;
  while j <= (550 - y) do
  begin
    process(j);
    inc(j, x);
  end;

  j := 22;
  while j >= -28 do
  begin
    process(j);
    dec(j, three);
  end;

  j := 1927;
  while j <= 1939 do
  begin
    process(j);
    inc(j);
  end;

  j := x;
  while j >= y do
  begin
    process(j);
    dec(j, -z);
  end;

  j := p;
  while j <= p + one do
  begin
    process(j);
    inc(j);
  end;

  writeln(format('sum  =  %d  ', [sum]));
  writeln(format('prod =  %d  ', [prod]));
  Readln;
end.
