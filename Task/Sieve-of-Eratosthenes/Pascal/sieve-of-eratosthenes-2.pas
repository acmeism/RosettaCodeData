program prim(output);
//Sieve of Erathosthenes with fast elimination of multiples of small primes
{$IFNDEF FPC}
  {$APPTYPE CONSOLE}
{$ENDIF}
const
  PrimeLimit = 100*1000*1000;//1;
type
  tLimit = 1..PrimeLimit;
var
  //always initialized with 0 => false at startup
  primes: array [tLimit] of boolean;

function BuildWheel: longInt;
//fill primfield with no multiples of small primes
//returns next sieveprime
//speedup ~1/3
var
  //wheelprimes = 2,3,5,7,11... ;
  //wheelsize = product [i= 0..wpno-1]wheelprimes[i] > Uint64 i> 13
  wheelprimes :array[0..13] of byte;
  wheelSize,wpno,
  pr,pw,i, k: LongWord;
begin
  //the mother of all numbers 1 ;-)
  //the first wheel = generator of numbers
  //not divisible by the small primes first found primes
  pr := 1;
  primes[1]:= true;
  WheelSize := 1;

  wpno := 0;
  repeat
    inc(pr);
    //pw = pr projected in wheel of wheelsize
    pw := pr;
    if pw > wheelsize then
      dec(pw,wheelsize);
    If Primes[pw] then
    begin
//      writeln(pr:10,pw:10,wheelsize:16);
      k := WheelSize+1;
      //turn the wheel (pr-1)-times
      for i := 1 to pr-1 do
      begin
        inc(k,WheelSize);
        if k<primeLimit then
          move(primes[1],primes[k-WheelSize],WheelSize)
        else
        begin
          move(primes[1],primes[k-WheelSize],PrimeLimit-WheelSize*i);
          break;
        end;
      end;
      dec(k);
      IF k > primeLimit then
        k := primeLimit;
      wheelPrimes[wpno] := pr;
      primes[pr] := false;

      inc(wpno);
      //the new wheelsize
      WheelSize := k;

      //sieve multiples of the new found prime
      i:= pr;
      i := i*i;
      while i <= k do
      begin
        primes[i] := false;
        inc(i,pr);
      end;
    end;
  until WheelSize >= PrimeLimit;

  //re-insert wheel-primes
  // 1 still stays prime
  while wpno > 0 do
  begin
    dec(wpno);
    primes[wheelPrimes[wpno]] := true;
  end;
  BuildWheel  := pr+1;
end;

procedure Sieve;
var
  sieveprime,
  fakt : LongWord;
begin
//primes[1] = true is needed to stop for sieveprime = 2
// at //Search next smaller possible prime
  sieveprime := BuildWheel;
//alternative here
  //fillchar(primes,SizeOf(Primes),chr(ord(true)));sieveprime := 2;
  repeat
    if primes[sieveprime] then
    begin
      //eliminate 'possible prime' multiples of sieveprime
      //must go downwards
      //2*2 would unmark 4 -> 4*2 = 8 wouldnt be unmarked
      fakt := PrimeLimit DIV sieveprime;
      IF fakt < sieveprime then
        BREAK;
      repeat
        //Unmark
        primes[sieveprime*fakt] := false;
        //Search next smaller possible prime
        repeat
          dec(fakt);
        until primes[fakt];
      until fakt < sieveprime;
    end;
    inc(sieveprime);
  until false;
  //remove 1
  primes[1] := false;
end;

var
  prCnt,
  i : LongWord;
Begin
  Sieve;
  {count the primes }
  prCnt := 0;
  for i:= 1 to PrimeLimit do
    inc(prCnt,Ord(primes[i]));
  writeln(prCnt,' primes up to ',PrimeLimit);
end.
