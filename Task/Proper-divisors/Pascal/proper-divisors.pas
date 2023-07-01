{$IFDEF FPC}{$MODE DELPHI}{$ELSE}{$APPTYPE CONSOLE}{$ENDIF}
uses
  sysutils;
const
  MAXPROPERDIVS = 1920;
type
  tRes = array[0..MAXPROPERDIVS] of LongWord;
  tPot = record
           potPrim,
           potMax :LongWord;
         end;

  tprimeFac = record
                 pfPrims : array[1..10] of tPot;
                 pfCnt,
                 pfNum   : LongWord;
               end;
  tSmallPrimes = array[0..6541] of longWord;

var
  SmallPrimes: tSmallPrimes;

procedure InitSmallPrimes;
var
  pr,testPr,j,maxprimidx: Longword;
  isPrime : boolean;
Begin
  maxprimidx := 0;
  SmallPrimes[0] := 2;
  pr := 3;
  repeat
    isprime := true;
    j := 0;
    repeat
      testPr := SmallPrimes[j];
      IF testPr*testPr > pr then
        break;
      If pr mod testPr = 0 then
      Begin
        isprime := false;
        break;
      end;
      inc(j);
    until false;

    if isprime then
    Begin
      inc(maxprimidx);
      SmallPrimes[maxprimidx]:= pr;
    end;
    inc(pr,2);
  until pr > 1 shl 16 -1;
end;

procedure PrimeFacOut(primeDecomp:tprimeFac);
var
  i : LongWord;
begin
  with primeDecomp do
  Begin
    write(pfNum,' = ');
    For i := 1 to pfCnt-1 do
      with pfPrims[i] do
        If potMax = 1 then
          write(potPrim,'*')
        else
          write(potPrim,'^',potMax,'*');
    with pfPrims[pfCnt] do
      If potMax = 1 then
        write(potPrim)
      else
        write(potPrim,'^',potMax);
  end;
end;

procedure PrimeDecomposition(n:LongWord;var res:tprimeFac);
var
  i,pr,cnt,quot{to minimize divisions} : LongWord;
Begin
  res.pfNum := n;
  res.pfCnt:= 0;
  i := 0;
  cnt := 0;
  repeat
    pr := SmallPrimes[i];
    IF pr*pr>n then
      Break;

    quot := n div pr;
    IF pr*quot = n then
      with res do
      Begin
        inc(pfCnt);
        with pfPrims[pfCnt] do
        Begin
          potPrim := pr;
          potMax := 0;
          repeat
            n := quot;
            quot := quot div pr;
            inc(potMax);
          until pr*quot <> n;
        end;
      end;
     inc(i);
  until false;
  //a big prime left over?
  IF n <> 1 then
    with res do
    Begin
      inc(pfCnt);
      with pfPrims[pfCnt] do
      Begin
        potPrim := n;
        potMax := 1;
      end;
    end;
end;

function CntProperDivs(const primeDecomp:tprimeFac):LongWord;
//count of proper divisors
var
   i: LongWord;
begin
  result := 1;
  with primeDecomp do
    For i := 1 to pfCnt do
      result := result*(pfPrims[i].potMax+1);
  //remove
  dec(result);
end;

function findProperdivs(n:LongWord;var res:TRes):LongWord;
//simple trial division to get a sorted list of all proper divisors
var
  i,j: LongWord;
Begin
  result := 0;
  i := 1;
  j := n;
  while j>i do
  begin
    j := n DIV i;
    IF i*j = n then
    Begin
      //smaller factor part at the beginning upwards
      res[result]:= i;
      IF i <> j then
        //bigger factor at the end downwards
        res[MAXPROPERDIVS-result]:= j
      else
        //n is square number
        res[MAXPROPERDIVS-result]:= 0;
      inc(result);
    end;
    inc(i);
  end;

  If result>0 then
  Begin
    //move close together
    i := result;
    j := MAXPROPERDIVS-result+1;
    result := 2*result-1;
    repeat
      res[i] := res[j];
      inc(j);
      inc(i);
    until i > result;

    if res[result-1] = 0 then
      dec(result);
  end;
end;

procedure AllFacsOut(n: Longword);
var
  res:TRes;
  i,k,j:LongInt;
Begin
   j := findProperdivs(n,res);
   write(n:5,' : ');
   For k := 0 to j-2 do write(res[k],',');
   IF j>=1 then
     write(res[j-1]);
   writeln;
end;

var
  primeDecomp: tprimeFac;
  rs : tRes;
  i,j,max,maxcnt: LongWord;
BEGIN
  InitSmallPrimes;
  For i := 1 to 10 do
    AllFacsOut(i);
  writeln;
  max    := 0;
  maxCnt := 0;
  For i := 1 to 20*1000 do
  Begin
    PrimeDecomposition(i,primeDecomp);
    j := CntProperDivs(primeDecomp);
    IF j> maxCnt then
    Begin
      maxcnt := j;
      max := i;
    end;
  end;
  PrimeDecomposition(max,primeDecomp);
  j := CntProperDivs(primeDecomp);

  PrimeFacOut(primeDecomp);writeln('  ',j:10,' factors'); writeln;
  //https://en.wikipedia.org/wiki/Highly_composite_number <= HCN
  //http://wwwhomes.uni-bielefeld.de/achim/highly.txt the first 1200 HCN
  max := 3491888400;
  PrimeDecomposition(max,primeDecomp);
  j := CntProperDivs(primeDecomp);
  PrimeFacOut(primeDecomp);writeln('  ',j:10,' factors'); writeln;
END.
