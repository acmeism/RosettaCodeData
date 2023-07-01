program p196;
{$IFDEF FPC}
  {$R-}
  {$MODE DELPHI}
  {$Optimization ON}
{$Else}
  {$APPTYPE console}
{$Endif}
{
nativeUint = LongWord;//Uint64
nativeInt = LongInt;//Int64
}

uses
  SysUtils,classes;

const
  cMAXNUM     = 100*1000*1000;//100*1000*1000;
  cMaxCycle   = 1500;
  cChkDigit   =   10;//first check lychrel found
  MaxLen      =  256;//maximal count of digits
  cMaxDigit   =  MAXLEN-1;

type
  TDigit = byte;
  tpDigit =^TDigit;
  tDigitArr = array[0..0] of tDigit;
  tpDigitArr = ^tDigitArr;
  //LSB at position 0
  TNumber = record
               nNum : array [0..cMaxDigit] of TDigit;
               nMaxPos : LongInt;
            end;
  tRelated = array[0..cMAXNUM] of byte;

procedure NumberFromString(var Number: TNumber; S: string);
var
  i,le: integer;
begin
  le := Length(s);
  IF le > cMaxDigit then
    le := cMaxDigit;
  Number.nMaxPos:= le-1;
  for i:= 0 to le-1 do
    Number.nNum[i]:= Ord(s[le- i]) - Ord('0');
end;

function NumberToString(var Number: TNumber): string;
var
  i,l: integer;
begin
  i := Number.nMaxPos;
  If i <= MAXLEN then
  begin
    SetLength(Result, i+1);
    l := i+1;
    i := 0;
    repeat
      Result[l]:= Chr(Ord('0') + Number.nNum[i]);
      inc(i);
      dec(l);
    until l <= 0;
  end
  else
  begin
    SetLength(Result, MAXLEN);
    fillchar(Result[1],MAXLEN,'.');
    For l := 1 to MAXLEN DIV 2-1 do
    Begin
      Result[l] := Chr(Ord('0') + Number.nNum[i-l+1]);
      Result[l+MAXLEN DIV 2+1] := Chr(Ord('0') + Number.nNum[24-l]);
    end;
  end;
end;

procedure CorrectCarry(var Number : TNumber);
//correct sum of digit to digit and carry
//without IF d>10 then...
var
  d,i,carry: nativeInt;
  p: tpDigitArr;
begin
  carry  := 0;
  i := Number.nMaxPos;
  p := @Number.nNum[i];
  i := -i;
  For i := i to 0 do
  Begin
   d := p^[i]+carry;
   carry := ord(d>=10);//0, 1-> (-10 AND(-carry) = 0 ,-10
   p^[i] := d+(-10 AND(-carry));
  end;
  //correct length
  IF carry >0 then
  begin
    i := Number.nMaxPos+1;
    Number.nNum[i] :=1;
    NUmber.nMaxPos := i;
  end;
end;

procedure NumberAdd(var Number : TNumber);
// first add than correct carry
var
  //pointer, for fpc is a little bit slow with dynamic array
  loIdx,hiIdx: integer;
  sum: nativeUint;
begin
  loIdx := 0;
  hiIdx := Number.nMaxPos;
  while loIdx< hiIdx  do
  Begin
    sum := Number.nNum[loIdx]+Number.nNum[hiIdx];
    Number.nNum[loIdx] := sum;
    Number.nNum[hiIdx] := sum;
    inc(loIdx);
    dec(HiIdx);
  end;

  IF loIdx = hiIdx then
    Number.nNum[loIdx] := 2*Number.nNum[loIdx];

  CorrectCarry(Number);
end;

function PalinCheck(var A: TNumber): boolean;
var
  loIdx,hiIdx: integer;
begin
  loIdx := 0;
  hiIdx := A.nMaxPos;
  repeat
    Result:= A.nNum[loIdx]=A.nNum[hiIdx];
    inc(loIdx);
    dec(hiIdx);
  until Not(Result) OR (hiIdx<loIdx);
end;

procedure ShowPalinLychrel(var Related:tRelated);
var
  i : NativeInt;
  s : string;
  slRes : TStringList;
  Work: TNumber;
Begin
  slRes := TStringList.create;

  For i := 0 to  High(Related) do
  begin
    IF Related[i] <> 0 then
    Begin
      s := IntToSTr(i);
      NumberFromString(Work,s);
      If PalinCheck(Work) then
        slRes.Add(s);
    end;
  end;

  Writeln('number of palindromatic lychrel ',slRes.count:8);
  IF slRes.Count < 10 then
  Begin
    For i := 0 to slRes.count-2 do
      write(slRes[i]:8,',');
    writeln(slRes[slRes.count-1]:8);
  end;
  slRes.free;
end;

var
  Related : tRelated;
  slSeedCache,
  slFirstChkCache : TStringList;

  Seeds : array of LongInt;
  Work: TNumber;
  num,findpos,InsPos : LongInt;
  relCount : NativeUint;
  s,f: string;

  procedure FirstCheckCache;
  //Test if Work is already in Cache
  //if not it will be inserted
  //Inspos saves the position
  var
    i : LongInt;
  Begin
    f:= NumberToString(Work);
    IF slFirstChkCache.find(f,i) then
    Begin
      IF slFirstChkCache.Objects[i]<> NIL then
      Begin
        Related[num] := 2;
        inc(RelCount);
      end;
    end
    else
    Begin
     //memorize the number as Object
      InsPos := slFirstChkCache.addObject(f,TObject(num));
    end;
  end;

begin
  fillchar(Related[1],Length(Related),#0);
  relCount := 0;

  slSeedCache := TStringList.create;
  slSeedCache.sorted := true;
  slSeedCache.duplicates := dupIgnore;

  slFirstChkCache := TStringList.create;
  slFirstChkCache.sorted := true;
  slFirstChkCache.duplicates := dupIgnore;

  setlength(Seeds,0);

  num := 1;
  repeat
    s := IntToStr(num);
    NumberFromString(Work, s);

    findPos := -1;
    InsPos  := -1;

    //early test if already in Cache
    repeat
      NumberAdd(Work);
      IF (Work.nMaxPos = cChkDigit) then
      Begin
        FirstCheckCache;
        BREAK;
      end;
    until PalinCheck(Work);

    //IF new number of cChkDigit length inserted in Cache
    IF (InsPos >= 0) AND NOT (PalinCheck(Work)) then
    Begin
      //check for lychrel
      while Work.nMaxPos < cMaxDigit do
      Begin
        NumberAdd(Work);
        if PalinCheck(Work) then
          BREAK;
      end;

      if Work.nMaxPos >= cMaxDigit then
      Begin
        f := NumberToString(Work);
        //new lychrel seed found
        IF NOT(slSeedCache.find(f,findPos)) then
        Begin
          //memorize the number by misusing of Object
          slSeedCache.addObject(f,TObject(num));
          setlength(Seeds,length(Seeds)+1);
          Seeds[High(Seeds)] := num;
          Related[num] := 1;
        end
        else
        Begin
          //a new way to known lycrel seed found, so memorize it
          Related[num] := 2;
          inc(RelCount)
        end
      end
      else
        //mark slFirstChkCache[InsPos] as not_lychrel
        slFirstChkCache.Objects[InsPos] := NIL;
    end;
    inc(num);
  until num > cMAXNUM;
  writeln ('Lychrel from 1 to ',cMAXNUM);
  writeln('number of cached ',cChkDigit,' digit ',slFirstChkCache.Count);
  writeln('number of lychrel seed          ',length(Seeds):8);
  IF length(Seeds) < 10 then
  Begin
    For InsPos:= 0 to High(Seeds)-1 do
      write(Seeds[InsPos],',');
    writeln(Seeds[High(seeds)]);
  end;
  writeln('number of lychrel related       ',RelCount:8);
  ShowPalinLychrel(Related);
  slFirstChkCache.free;
  slSeedCache.free;
  setlength(Seeds,0);
end.
{
...
Lychrel from 1 to 100000000
number of cached 10 digit 7008
number of lychrel seed              3552
number of lychrel related       28802508
number of palindromatic lychrel     5074

real  0m48.634s
user  0m48.579s
sys 0m0.012s
}
