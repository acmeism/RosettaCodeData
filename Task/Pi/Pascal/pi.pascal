Program Pi_Spigot;
const
  n   = 1000;
  len = 10*n div 3;

var
  j, k, q, nines, predigit: integer;
  a: array[0..len] of longint;

function OneLoop(i:integer):integer;
var
  x: integer;
begin
  {Only calculate as far as needed }
  {+16 for security digits ~5 decimals}
  i := i*10 div 3+16;
  IF i > len then
    i := len;
  result := 0;
  repeat   {Work backwards}
    x  := 10*a[i] + result*i;
    result := x div (2*i - 1);
    a[i]   := x - result*(2*i - 1);//x mod (2*i - 1)
    dec(i);
  until i<= 0 ;
end;

begin

  for j := 1 to len do
    a[j] := 2;                 {Start with 2s}
  nines := 0;
  predigit := 0;               {First predigit is a 0}

  for j := 1 to n do
  begin
    q := OneLoop(n-j);
    a[1] := q mod 10;
    q := q div 10;
    if q = 9 then
      nines := nines + 1
    else
      if q = 10 then
      begin
        write(predigit+1);
        for k := 1 to nines do
          write(0);            {zeros}
        predigit := 0;
        nines := 0
      end
      else
      begin
        write(predigit);
        predigit := q;
        if nines <> 0 then
        begin
          for k := 1 to nines do
            write(9);
          nines := 0
        end
      end
  end;
  writeln(predigit);
end.
