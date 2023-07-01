program Root3rd_divs_n.pas;
{$IFDEF FPC}
  {$MODE DELPHI}  {$OPTIMIZATION ON,ALL}  {$COPERATORS ON}
{$ENDIF}
{$IFDEF WINDOWS}
  {$APPTYPE CONSOLE}
{$ENDIF}
uses
  sysutils
{$IFDEF WINDOWS},Windows{$ENDIF}
  ;
const
  limit = 110*1000 *1000;
var
  sol : array [0..limit] of byte;
  primes : array of Uint32;
  gblCount: Uint64;

procedure SievePrimes(lmt:Uint32);
var
  sieve : array of byte;
  p,i,delta : NativeInt;
Begin
  setlength(sieve,lmt DIV 2);
  //estimate count of prime
  i := trunc(lmt/(ln(lmt)-1.1));
  setlength(primes,i);
  p := 1;
  repeat
    delta := 2*p+1;
    // ((2*p+1)^2 ) -1)/ 2 = ((4*p*p+4*p+1) -1)/2 = 2*p*(p+1)
    i := 2*p*(p+1);
    if i>High(sieve) then
      BREAK;
    while i <= High(sieve) do
    begin
      sieve[i] := 1;
      i += delta;
    end;
    repeat
      inc(p);
    until sieve[p] = 0;
  until false;

  primes[0] := 2;
  i := 1;
  For p := 1 to High(sieve) do
    if  sieve[p] = 0 then
    begin
      primes[i] := 2*p+1;
      inc(i);
    end;
  setlength(primes,i);
end;

procedure Get_a7;
var
  q3,n : UInt64;
  i : nativeInt;
begin
  sol[1] := 1;
  gblCount +=1;
  For i := 0 to High(primes) do
  begin
    q3 := primes[i];
    n := sqr(sqr(sqr(q3))) DIV q3;
    if n > limit then
      break;
    sol[n] := 1;
    gblCount +=1;
  end;
end;

procedure Get_a3_b;
var
  i,j,q3,n : nativeInt;
begin
  For i := 0 to High(primes) do
  begin
    q3 := primes[i];
    q3 := q3*q3*q3;
    if q3 > limit then
      BREAK;
    For j := 0 to High(primes) do
    begin
      if j = i then
        continue;
      n := Primes[j]*q3;
      if n > limit then
        BREAK;
      sol[n] := 1;
      gblCount +=1;
    end;
  end;
end;

procedure Get_a_b_c;
var
  i,j,k,q1,q2,n : nativeInt;
begin
  For i := 0 to High(primes)-2 do
  begin
    q1 := primes[i];
    For j := i+1 to High(primes)-1 do
    Begin
      q2:= q1*Primes[j];
      if q2 > limit then
        BREAK;
      For k := j+1 to High(primes) do
      Begin
        n:= q2*Primes[k];
        if n > limit then
          BREAK;
        sol[n] := 1;
        gblCount +=1;
      end;
    end;
  end;
end;

var
  i,cnt,lmt : Int32;
begin
  SievePrimes(limit DIV 6);// 2*3*c * (c> 3 prime)

  gblCount := 0;
  Get_a7;
  Get_a3_b;
  Get_a_b_c;

  Writeln('First 50 numbers which are the cube roots of the products of their proper divisors:');
  cnt := 0;
  i := 1;

  while cnt < 50 do
  begin
    if sol[i] <> 0 then
    begin
      write(i:5);
      cnt +=1;
      if cnt mod 10 = 0 then writeln;
    end;
    inc(i);
  end;
  dec(i);
  lmt := 500;
  repeat
    while cnt < lmt do
    begin
      inc(i);
      if sol[i] <> 0 then
        cnt +=1;
      if i > limit then
        break;
    end;
    if i > limit then
      break;
    writeln(lmt:8,'.th:',i:12);
    lmt *= 10;
  until lmt> limit;
  writeln('Total found: ', gblCount, ' til ',limit);
end.
