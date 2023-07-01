{$mode Delphi}

{ Note that for the program to work properly,
  integer variables must be at least 28-bit.
  Free Pascal Compiler uses 16-bit integers by default,
  so a directive like above is needed. }

program ascendingprimes(output);

const maxsize = 1000;

var
  queue, primes : array[1..maxsize] of integer;
  b, e, n, k, v : integer;


function isprime(n: integer): boolean;

  var
    ans : boolean;
    root, k : integer;
  begin
    if n = 2 then
      ans := true
    else if (n = 1) or (n mod 2 = 0) then
      ans := false
    else
    begin
      root := trunc(sqrt(n));
      ans := true;
      k := 3;
      while ans and (k <= root) do
        if n mod k = 0 then
          ans := false
        else
          k := k + 2;
    end;
    isprime := ans
  end;

begin

  b := 1;
  e := 1;
  n := 0;

  for k := 1 to 9 do
  begin
    queue[e] := k;
    e := e + 1
  end;

  while b < e do
  begin
    v := queue[b];
    b := b + 1;
    if isprime(v) then
    begin
      n := n + 1;
      primes[n] := v
    end;

    for k := v mod 10 + 1 to 9 do
    begin
      queue[e] := v * 10 + k;
      e := e + 1
    end

  end;

  for k := 1 to n do
    write(primes[k], ' ');
  writeln()

end.
