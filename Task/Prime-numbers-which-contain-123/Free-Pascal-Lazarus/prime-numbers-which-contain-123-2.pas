program Primes_123;
{$IFDEF FPC}
  {$MODE objFPC}
  {$CODEALIGN proc=32,loop=1}
{$IFEND}
uses
  sysutils,StrUtils,primsieve;
const
  C123 = 123;
  cLen123 = 3;
  cPow10_3 = 1000;
  cArrLenDgtCnt :array[cLen123..11] of Integer =
             (1,14,185,2300,27500,320000,3650000,41000000,455000000);
const
  MaxTotLen = 11;
var
  PoW10: array[0..MaxTotLen] of int64;
  SortArray : array of NativeInt;
  SortArrayIdx  : nativeint;

  procedure QuickSort(var A: array of NativeInt;MaxIdx:NativeInt);
    procedure QSort(L, R: Integer);
    var
      I, J, Tmp, Pivot: NativeInt;
    begin
    if R - L < 1 then exit;
      I := L; J := R;
      {$push}{$q-}{$r-}Pivot := A[(L + R) shr 1];{$pop}
      repeat
        while A[I] < Pivot do Inc(I);
        while A[J] > Pivot do Dec(J);
        if I <= J then begin
          Tmp := A[I];
          A[I] := A[J];
          A[J] := Tmp;
          Inc(I); Dec(J);
        end;
      until I > J;
      QSort(L, J);
      QSort(I, R);
    end;
  begin
    QSort(0, MaxIdx-1);
  end;

  function Check(DgtCnt:NativeInt;var lastP:NativeInt):NativeInt;
  //sort numbers and check if prime and return count
  var
    pArr : pNativeInt;
    i,
    num123,
    p: NativeInt;
  begin
    QuickSort(SortArray,SortArrayIdx-1);
    pArr := @SortArray[0];
    p := Lastp;
    result := 0;
    num123 := 0;
    For i := 0 to SortArrayIdx-1 do
    begin
//    no doublettes
      if num123 <> pArr[i] then
      begin
        num123 := pArr[i];
        while p < num123 do
          p := NextPrime;
        if p= num123 then
          result += 1
      end;
    end;
    Lastp := p;
  end;

  procedure AddDgtAfter(before, cnt: nativeint);
  begin
    if cnt=1 then
    begin
      SortArray[SortArrayIdx] := before;
      SortArrayIdx +=1
    end
    else
    begin
      //make before odd
      before += Ord(Not(Odd(before)));
      repeat
        SortArray[SortArrayIdx] := before;
        SortArrayIdx += 1;
        before += 2;
        cnt -= 2;
      until cnt <=0;
    end;
  end;

procedure Get123NumbWithDgtCnt(DgtCnt:NativeInt);
//Creating numbers with at least one "123" with DgtCnt digits
var
  PowBefore: nativeint;
  DgtCntBefore,DgtCntAfter,DgtBefore: nativeint;
Begin
  DgtCntAfter := DgtCnt - cLen123;
  PowBefore := PoW10[DgtCntAfter];
  //DgtCntBefore = 0;
  AddDgtAfter(C123 * PowBefore, PowBefore);
  for DgtCntBefore := 1 to DgtCnt - cLen123 do
  begin
    DgtCntAfter -=1;
    PowBefore := PoW10[DgtCntAfter];
    for DgtBefore := Pow10[DgtCntBefore - 1] to Pow10[DgtCntBefore] - 1 do
      AddDgtAfter((DgtBefore * cPow10_3 + C123) * PowBefore, PowBefore );
  end;
end;

var
  MyTime : Int64;
  lastp,PowBefore: nativeint;
  TtlLen,TtlCnt: nativeint;
  i: nativeint;

begin

  myTime := GetTickCount64;
  PowBefore := 1;

  for i := 0 to MaxTotLen do
  begin
    PoW10[i] := PowBefore;
    PowBefore *= 10;
  end;
  //generating numbers containing "123", unordered :-(
  //first 123_0,123_1,..,123_9 than 1_123,2_123,3_123
  TtlLen := cLen123;
  TtlCnt := 0;

  setlength(SortArray,cArrLenDgtCnt[MaxTotLen]);
  SortArrayIdx := 0;

  lastp := 0;
  writeln('Initial time ',(GetTickCount64-myTime)*0.001:8:3,' s');
  myTime := GetTickCount64;
  Writeln('Count of primes in decimal containing "123"');
  Writeln('total count':15,'Limit':20);
  repeat
    Get123NumbwithDgtCnt(TtlLen);
    inc(TtlCnt,Check(TtlLen,Lastp));
    Writeln(Numb2USA(IntTosTr(TtlCnt)):15,
            Numb2USA(IntTosTr(PoW10[TtlLen]-1)):20,
            (GetTickCount64-myTime)*0.001:8:3,' s');
    SortArrayIdx := 0;
    Inc(TtlLen);
  until TtlLen > MaxTotLen;

  setlength(SortArray,0);
end.
