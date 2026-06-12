program primeRezSum;
{$IFDEF FPC}  {$MODE DELPHI}{$Optimization ON,ALL} {$ENDIF}
{$IFDEF WINDOWS}{$APPTYPE CONSOLE}{$ENDIF}
uses
  sysutils,
  gmp;
const
  PrimeCount =   6542;
  PRIMEMAXVAL = 65535;
  SIEVESIZE = 65536;
type
  Tsieveprime = record
                  prime,
                  offset : Uint16;
                end;
  tSievePrimes = array[0..PrimeCount-1] of Tsieveprime;
  tSieve       = array[0..SIEVESIZE-1] of byte;
var
  s : AnsiString;
  MyPrimes : tSievePrimes;
  sieve : tSieve;
procedure OutStr(const s: AnsiString);
var
  myString : AnsiString;
  l : Integer;
begin
  myString := copy(s,1,length(s));
  l :=length(pChar(@s[1]));
  setlength(myString,l);
  IF l< 41 then
    writeln(myString)
  else
  begin
    myString[20]:= #0;
    myString[21]:= #0;
    writeln(pChar(@myString[1]),'...',pChar(@myString[l-19]),' (',l:6,' digits)');
  end;
end;

function InitPrimes:Uint32;
var
  f : extended;
  idx,p,pr_cnt : Uint32;
Begin
  fillchar(sieve,Sizeof(sieve),#0);
  pr_cnt := 0;
  p := 2;
  f := 1.0;
  repeat
     while Sieve[p]<> 0 do
       inc(p);
     MyPrimes[pr_cnt].prime := p;
     f := f*(p-1)/p;
     inc(pr_cnt);
     idx := p*p;
     if idx > PRIMEMAXVAL then
       Break;
     repeat
       sieve[idx] := 1;
       inc(idx,p);
     until idx > high(sieve);
     inc(p);
  until sqr(p)>PRIMEMAXVAL;

  while (pr_cnt<= High(MyPrimes)) AND (p<PRIMEMAXVAL)  do
  begin
    while Sieve[p]<> 0 do
      inc(p);
    MyPrimes[pr_cnt].prime := p;
    f := f*(p-1)/p;
    inc(p);
    inc(pr_cnt);
  end;
  Writeln ('reducing factor ',f:10:8);
  result := pr_cnt-1;
end;

procedure DoSieveOffsetInit(var tmp:mpz_t);
var
  dummy :mpz_t;
  i,j,p : Uint32;
Begin
  mpz_init(dummy);
  for i := 0 to High(MyPrimes) do
    with MyPrimes[i] do
    Begin
      if prime = 0 then  Begin  writeln(i);halt;end;
      offset := prime-mpz_tdiv_q_ui(dummy,tmp,prime);
    end;
  mpz_set(dummy,tmp);
  repeat
    //one sieve
    fillchar(sieve,Sizeof(sieve),#0);
    //sieve
    For i := 0 to High(MyPrimes) do
    begin
      with MyPrimes[i] do
      begin
        p := prime;
        j := offset;
      end;
      repeat
        sieve[j] := 1;
        j += p;
      until j >= SIEVESIZE;
      MyPrimes[i].offset := j-SIEVESIZE;
    end;

    j := 0;
    For i := 0 to High(sieve) do
    begin
//  function mpz_probab_prime_p(var n: mpz_t; reps: longint): longint;1 = prime
      if (sieve[i]= 0) then
      begin
        mpz_add_ui(dummy,dummy,i-j);
        j := i;
        if (mpz_probab_prime_p(dummy,1) >0)  then
        begin
          mpz_set(tmp,dummy);
          mpz_clear(dummy);
          EXIT;
        end;
      end;
    end;
  until false;
end;

var
  nominator,denominator,tmp,tmpDemP,p : mpz_t;
  T1,T0:Int64;
  cnt : NativeUint;
begin
  InitPrimes;
  setlength(s,100000);
  cnt := 1;
  mpz_init(nominator);
  mpz_init(tmp);
  mpz_init(tmpDemP);
  mpz_init_set_ui(denominator,1);
  mpz_init_set_ui(p,1);

  repeat
    mpz_set(tmpDemP,p);
    T0 := GetTickCount64;
    if cnt > 9 then
      DoSieveOffsetInit(p)
    else
      mpz_nextprime(p,p);
    T1 := GetTickCount64;
    write(cnt:3,'  ',T1-T0,' ms ,delta ');
    mpz_sub(tmpDemP,p,tmpDemP);
    mpz_get_str(pChar(@s[1]),10, tmpDemP); OutStr(s);
    mpz_get_str(pChar(@s[1]),10, p); OutStr(s);
    if cnt >=15 then
      Break;
    repeat
      mpz_mul(tmp,nominator,p);
      mpz_add(tmp,tmp,denominator);
      mpz_mul(tmpDemP,denominator,p);
      if mpz_cmp(tmp,tmpDemP)< 0 then
        BREAK;
      mpz_add_ui(p,p,1);
    until false;
    mpz_set(nominator,tmp);
    mpz_mul(denominator,denominator,p);

    //next smallest possible number denominator/delta
    mpz_sub(tmp,denominator,nominator);
    mpz_fdiv_q(p,denominator,tmp);

    inc(cnt);
  until cnt> 17;
end.
