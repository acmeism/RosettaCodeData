program unprimable;
{$IFDEF FPC}
  {$Mode Delphi}
  {$OPTIMIZATION ON,ALL}
{$ELSE}
  //Delphi
  {$APPTYPE CONSOLE}
{$ENDIF}
uses
  sysutils;
const
  Base = 10;
  dgtcnt = 9;
  Limit = Base* Base*Base*Base*Base* Base*Base*Base*Base;
{
  Base = 18;
  dgtcnt = 8;
  Limit = Base*Base*Base*Base* Base*Base*Base*Base;
  * }

  PrimeLimit = Limit+Base;
{
  Limit = 1000*1000*1000;
  dgtcnt = trunc(ln(Limit-1)/ln(Base));
  PrimeLimit = Trunc(exp(ln(base)*(dgtcnt+1)))+Base;
}
type
  TNumVal = array[0..dgtcnt] of NativeUint;
  TConvNum = record
               NumRest,
               Digits : TNumVal;
               num,
               MaxIdx : NativeUint;
             end;

var //global
  ConvNum:TConvNum;
  PotBase: TNumVal;
  EndDgtFound : array[0..Base-1] of NativeUint;
  TotalCnt,
  EndDgtCnt :NativeUint;

//http://rosettacode.org/wiki/Sieve_of_Eratosthenes#alternative_using_wheel

var
  pPrimes : pBoolean;
  //always initialized with 0 => false at startup
  primes: array  of boolean;

function BuildWheel: NativeUint;
var
  myPrimes : pBoolean;
  wheelprimes :array[0..31] of byte;
  wheelSize,wpno,
  pr,pw,i, k: NativeUint;
begin
  myPrimes := @primes[0];
  pr := 1;
  myPrimes[1]:= true;
  WheelSize := 1;

  wpno := 0;
  repeat
    inc(pr);

    pw := pr;
    if pw > wheelsize then
      dec(pw,wheelsize);
    If myPrimes[pw] then
    begin
      k := WheelSize+1;
      //turn the wheel (pr-1)-times
      for i := 1 to pr-1 do
      begin
        inc(k,WheelSize);
        if k<primeLimit then
          move(myPrimes[1],myPrimes[k-WheelSize],WheelSize)
        else
        begin
          move(myPrimes[1],myPrimes[k-WheelSize],PrimeLimit-WheelSize*i);
          break;
        end;
      end;
      dec(k);
      IF k > primeLimit then
        k := primeLimit;
      wheelPrimes[wpno] := pr;
      myPrimes[pr] := false;

      inc(wpno);
      //the new wheelsize
      WheelSize := k;

      //sieve multiples of the new found prime
      i:= pr;
      i := i*i;
      while i <= k do
      begin
        myPrimes[i] := false;
        inc(i,pr);
      end;
    end;
  until WheelSize >= PrimeLimit;

  //re-insert wheel-primes 1 still stays prime
  while wpno > 0 do
  begin
    dec(wpno);
    myPrimes[wheelPrimes[wpno]] := true;
  end;
  myPrimes[0] := false;
  myPrimes[1] := false;

  BuildWheel  := pr+1;
  writeln;
end;

procedure Sieve;
var
  myPrimes : pBoolean;
  sieveprime,
  fakt : NativeUint;
begin
  setlength(Primes,PrimeLimit+1);
  pPrimes := @Primes[0];
  myPrimes := pPrimes;
//pPrimes[1] = true is needed to stop for sieveprime = 2
// at //Search next smaller possible prime
  sieveprime := BuildWheel;
//alternative here
  //fillchar(pPrimes,SizeOf(pPrimes),chr(ord(true)));sieveprime := 2;
  repeat
    if myPrimes[sieveprime] then
    begin
      //eliminate 'possible prime' multiples of sieveprime
      //must go downwards
      //2*2 would unmark 4 -> 4*2 = 8 wouldnt be unmarked
      fakt := PrimeLimit DIV sieveprime;
      IF fakt < sieveprime then
        BREAK;
      repeat
        //Unmark
        myPrimes[sieveprime*fakt] := false;
        //Search next smaller possible prime
        repeat
          dec(fakt);
        until myPrimes[fakt];
      until fakt < sieveprime;
    end;
    inc(sieveprime);
  until false;
  //remove 1
  myPrimes[1] := false;
end;

procedure Init;
var
  i,val : NativeUint;
Begin
  val := 1;
  For i := low(TNumVal) to High(TNumVal) do
  Begin
    EndDgtFound[i] :=0;
    PotBase[i] := val;
    val := val * Base;
  end;
  TotalCnt := 0;
  EndDgtCnt := 0;
end;

procedure OutConvNum(const NConv:TConvNum);
var
  i : NativeInt;
Begin
  with NConv do
  begin
    writeln(num,MaxIdx:10);
    For i := MaxIdx Downto MaxIdx do
      write(Digits[i]);
    writeln;
    For i := MaxIdx Downto MaxIdx do
      write(NumRest[i]:8);
  end
end;

procedure IncConvertNum(var NConv:TConvNum);
var
  i,k : NativeInt;
Begin
  with NConv do
  begin
    i := 0;
    repeat
      k := Digits[i]+1;
      IF k < Base then
      Begin
        Digits[i] := k;
        BREAK;
      end
      else
      Begin
        Digits[i] := k-Base;
        inc(i);
      end;
    until i > MaxIdx;
    IF i > MaxIdx then
    Begin
      Digits[i] := 1;
      MaxIdx := i;
    end;

    k := num+1;
    i := MaxIdx;
    repeat
      NumRest[i]:= k-Digits[i]*PotBase[i];
      dec(i);
    until i < 0;
    num := k;
  end;
end;

procedure IncConvertNumBase(var NConv:TConvNum);
var
  i,k : NativeInt;
Begin
  with NConv do
  begin
    i := 1;
    Digits[0] := 0;
    repeat
      k := Digits[i]+1;
      IF k < Base then
      Begin
        Digits[i] := k;
        BREAK;
      end
      else
      Begin
        Digits[i] := k-Base;
        inc(i);
      end;
    until i > MaxIdx;
    IF i > MaxIdx then
    Begin
      Digits[i] := 1;
      MaxIdx := i;
    end;
    k := num+Base;
    i := MaxIdx;
    repeat
      NumRest[i]:= k-Digits[i]*PotBase[i];
      dec(i);
    until i < 0;
    num := k;
  end;
end;

Procedure ConvertNum(n: NativeUint;var NConv:TConvNum);
//extract digit position replace by "0" to get NumRest
// 173 -> 170 -> 103 -> 073
var
  i, dgt,n_red,n_div: NativeUint;
begin
  i := 0;
  with NConv do
  Begin
    num := n;
    n_red := n;
    repeat
      n_div := n_red DIV Base;
      dgt := n_red-Base*n_div;
      n_red := n_div;
      Digits[i] := dgt;
      NumRest[i]:= n-dgt*PotBase[i];
      inc(i);
    until (n_red= 0)OR (i > High(TNumVal));
    MaxIdx := i-1;
  end;
end;

procedure InsertFound(dgt,n:NativeUInt);
Begin
  IF EndDgtFound[dgt] = 0 then
  Begin
    EndDgtFound[dgt] := n;
    inc(EndDgtCnt);
  end;
end;

function CheckUnprimable(const ConvNum:TConvNum):boolean;
var
  myPrimes : pBoolean;
  val,dgt,i,dtfac: NativeUint;
Begin
  myPrimes := pPrimes;
  result := false;
  with ConvNum do
  Begin
    //lowest digit. Check only resulting odd numbers num > base
    val := NumRest[0];
    dgt := 1- (val AND 1);
    repeat
      IF myPrimes[val+dgt] then
        EXIT;
      inc(dgt,2);
    until dgt >= Base;

    For i := 1 to MaxIdx do
    Begin
      val := NumRest[i];
      dtfac := PotBase[i];
      IF (val >= BASE) then
      Begin
        IF NOt(Odd(val)) AND NOT(ODD(dtfac))  then
          continue;
        For dgt := 0 to Base-1 do
        Begin
          IF myPrimes[val] then
            EXIT;
          inc(val,dtfac);
        end;
      end
      else
      Begin
        For dgt := 0 to Base-1 do
        Begin
          IF myPrimes[val] then
            EXIT;
          inc(val,dtfac);
        end;
      end
    end;
    inc(TotalCnt);
    result := true;
  end;
end;

var
  n,i,Lmt,Lmt10 : NativeUint;
Begin
  init;
  Sieve;
  n := Base;
  Lmt10 := 10;
  Lmt := Base;
  ConvertNum(n,ConvNum);
  writeln('Base ',ConvNum.num);
  //InsertFound takes a lot of time.So check it as long as neccessary
  while EndDgtCnt <Base do
  Begin
    If CheckUnprimable(ConvNum) then
    Begin
      InsertFound(ConvNum.Digits[0],n);
      For i := 1 to Base-1 do
      Begin
        inc(n);
        IncConvertNum(ConvNum);
        IF CheckUnprimable(ConvNum) then
          InsertFound(ConvNum.Digits[0],n);
      end;
      inc(n);
      IncConvertNum(ConvNum);
    end
    else
    Begin
      inc(n,Base);
      IncConvertNumBase(ConvNum);
    end;
    if n >= Lmt10 then
    Begin
      writeln('There are ',TotalCnt,' unprimable numbers upto ',n);
      Lmt10 := Lmt10*10;
    end;
    if (Base <> 10) AND (n >= Lmt) then
    Begin
      writeln('There are ',TotalCnt,' unprimable numbers upto ',n);
      Lmt := Lmt*Base;
    end;
  end;
  //All found
  repeat
    If CheckUnprimable(ConvNum) then
    Begin
      For i := 1 to Base-1 do
      Begin
        inc(n);
        IncConvertNum(ConvNum);
        CheckUnprimable(ConvNum)
      end;
      inc(n);
      IncConvertNum(ConvNum);
    end
    else
    Begin
      inc(n,Base);
      IncConvertNumBase(ConvNum);
    end;

    if n >= Lmt10 then
    Begin
      writeln('There are ',TotalCnt,' unprimable numbers upto ',n);
      Lmt10 := Lmt10*10;
    end;

    if (Base <> 10) AND (n >= Lmt) then
    Begin
      writeln('There are ',TotalCnt,' unprimable numbers upto ',n);
      Lmt := Lmt*Base;
    end;
  until n >= Limit;
  writeln;
  For i := 0 to Base-1 do
    Writeln ('lowest digit ',i:2,' found first ',EndDgtFound[i]:7);
  writeln;
  writeln('There are ',TotalCnt,' unprimable numbers upto ',n);
  setlength(Primes,0);
end.
