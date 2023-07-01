program sphenic;
{$IFDEF FPC}{$MODE DELPHI}{$Optimization ON,ALL}{$CODEALIGn proc=16}{$ENDIF}
{$IFDEF WINDOWS}{$APPTYPE CONSOLE}{$ENDIF}
const
  Limit= 1000*1000;

type
  tPrimesSieve = array of boolean;
  tElement = Uint32;
  tarrElement = array of tElement;
  tpPrimes = pBoolean;

var
  PrimeSieve : tPrimesSieve;
  primes : tarrElement;
  sphenics : tarrElement;
  procedure ClearAll;
  begin
    setlength(sphenics,0);
    setlength(primes,0);
    setlength(PrimeSieve,0);
  end;
  function BuildWheel(pPrimes:tpPrimes;lmt:Uint32): longint;
  var
    wheelSize, wpno, pr, pw, i, k: NativeUint;
    wheelprimes: array[0..15] of byte;
  begin
    pr := 1;//the mother of all numbers 1 ;-)
    pPrimes[1] := True;
    WheelSize := 1;

    wpno := 0;
    repeat
      Inc(pr);
      //pw = pr projected in wheel of wheelsize
      pw := pr;
      if pw > wheelsize then
        Dec(pw, wheelsize);
      if pPrimes[pw] then
      begin
        k := WheelSize + 1;
        //turn the wheel (pr-1)-times
        for i := 1 to pr - 1 do
        begin
          Inc(k, WheelSize);
          if k < lmt then
            move(pPrimes[1], pPrimes[k - WheelSize], WheelSize)
          else
          begin
            move(pPrimes[1], pPrimes[k - WheelSize], Lmt - WheelSize * i);
            break;
          end;
        end;
        Dec(k);
        if k > lmt then
          k := lmt;
        wheelPrimes[wpno] := pr;
        pPrimes[pr] := False;
        Inc(wpno);

        WheelSize := k;//the new wheelsize
        //sieve multiples of the new found prime
        i := pr;
        i := i * i;
        while i <= k do
        begin
          pPrimes[i] := False;
          Inc(i, pr);
        end;
      end;
    until WheelSize >= lmt;

    //re-insert wheel-primes 1 still stays prime
    while wpno > 0 do
    begin
      Dec(wpno);
      pPrimes[wheelPrimes[wpno]] := True;
    end;
    result := pr;
  end;

  procedure Sieve(pPrimes:tpPrimes;lmt:Uint32);
  var
    sieveprime, fakt, i: UInt32;
  begin
    sieveprime := BuildWheel(pPrimes,lmt);
    repeat
      repeat
        Inc(sieveprime);
      until pPrimes[sieveprime];
      fakt := Lmt div sieveprime;
      while Not(pPrimes[fakt]) do
        dec(fakt);
      if fakt < sieveprime then
        BREAK;
      i := (fakt + 1) mod 6;
      if i = 0 then
        i := 4;
      repeat
        pPrimes[sieveprime * fakt] := False;
        repeat
          Dec(fakt, i);
          i := 6 - i;
        until pPrimes[fakt];
        if fakt < sieveprime then
          BREAK;
      until False;
    until False;
    pPrimes[1] := False;//remove 1
  end;

procedure InitAndGetPrimes;
var
  prCnt,i,lmt : UInt32;
begin
  setlength(PrimeSieve,Limit+1);// inits with #0
  lmt := Limit DIV (2*3);
  if Lmt < 65536 then
    setlength(Primes,6542)
  else
    setlength(Primes,trunc(lmt/(ln(lmt)-1.1)));
  Sieve(@PrimeSieve[0],lmt);
  prCnt := 0;
  for i := 1 to Lmt do
  Begin
    if PrimeSieve[i] then
    begin
      primes[prCnt] := i;
      inc(prCnt);
    end;
  end;
  setlength(primes,prCnt);
  // clear used by sieving section
  fillchar(PrimeSieve[0],Lmt+1,#0);
end;

function binary_search(value: Uint32;const A:tarrElement): Int32;
var
  p : Uint32;
  l, m, h: tElement;
begin
  l := Low(primes);
  h := High(primes);
  while l <= h do
  begin
    m := (l + h) div 2;
    p := A[m];
    if p > value then
    begin
      h := m - 1;
    end
    else
    begin
      if p < value then
      begin
        l := m + 1;
      end
      else
        exit(m);
    end;
  end;
  binary_search:=m;
end;

procedure CreateSphenics(const pr:tarrElement);
var
  i1,i2,i3,
  idx1,idx2,
  p1,p2,p,cnt : Uint32;
begin
  cnt := 0;
  p := trunc(exp(1/3*ln(Limit)));
  idx1 := binary_search(p,Pr)-1;
  i1 := 0;
  repeat
    p1 := pr[i1];
    p := trunc(sqrt(Limit DIV p1));
    idx2:= binary_search(p,Pr)+1;
    For i2 := i1+1 to idx2 do
    begin
      p2:= pr[i2]*p1;
      For i3 := i2+1 to High(pr) do
      begin
        p := Pr[i3]*p2;
        if p > Limit then
          break;
        //mark as sphenic number
        PrimeSieve[p]:= true;
        inc(cnt);
      end;
    end;
    inc(i1);
  until i1>idx1;
  //insert
  setlength(sphenics,cnt);
  p := 0;
  For i1 := 0 to Limit do
  begin
    if PrimeSieve[i1] then
    begin
      sphenics[p] := i1;
      inc(p);
    end;
  end;
end;

//alternativ with less variables, needs fast mul of CPU
(*
procedure CreateSphenics(const pr:tarrElement);
var
  cnt,i1,i2,i3,
  p1,p2,p : Uint32;
begin
  cnt := 0;
  i1 :=0;
  repeat
    p1 := Pr[i1];
    if p1*p1*p1 > Limit then
      BREAK;
    i2 := i1+1;
    repeat
      p := Pr[i2];
      if (p*p)*p1 > Limit then
        BREAK;
      p2:= p1*p;
      For i3 := i2+1 to High(Pr) do
      begin
        p := Pr[i3]*p2;
        if p > LIMIT then
          BREAK;
        PrimeSieve[p]:= true;
        inc(cnt);
      end;
      inc(i2)
    until false;
    inc(i1);
  until false;
  //insert
  setlength(sphenics,cnt);
  p := 0;
  For i1 := 0 to Limit do
  begin
    if PrimeSieve[i1] then
    begin
      sphenics[p] := i1;
      inc(p);
    end;
  end;
end;
*)

procedure OutTriplet(i:Uint32);
begin
  write('{',sphenics[i],',',sphenics[i+1],',',sphenics[i+2],'}');
end;

function CheckTriplets(i:Uint32):boolean;inline;
begin
  CheckTriplets:= PrimeSieve[i] AND PrimeSieve[i+1] AND PrimeSieve[i+2];
end;

var
  i,j,t5000 : Uint32;
begin
  InitAndGetPrimes;
  CreateSphenics(Primes);
  writeln('Sphenic numbers < 1,000:');
  i := 0;
  repeat
    if sphenics[i] > 1000 then
      break;
    write(sphenics[i]:4);
    inc(i);
    if i Mod 15 = 0 then
      writeln;
  until i>= High(sphenics);
  writeln;
  writeln('Sphenic triplets < 10,000:');
  i := 0;
  j := 0;
  repeat
    if CheckTriplets(sphenics[i]) then
    Begin
      OutTriplet(i);
      inc(j);
      if j < 3 then
        write(',')
      else
      begin
        writeln;
        j := 0;
      end;
    end;
    inc(i);
  until sphenics[i+2]>10000;
  writeln;
  i := 0;
  j := 0;
  writeln('There are ',length(sphenics),' sphenic numbers < ',limit);
  repeat
    if CheckTriplets(sphenics[i]) then
    Begin
       inc(j);
       if j = 5000 then
         t5000 := i;
    end;
    inc(i);
  until i+2 >high(sphenics);
  writeln('There are ',j,' sphenic triplets numbers < ',limit);
  writeln('The 200,000th sphenic number is ',sphenics[200000-1]);
  write('The 5,000th sphenic triplet is ');OutTriplet(T5000);
  ClearAll;
end.
