function IsPrime(N: int64): boolean;
{Fast, optimised prime test}
var I,Stop: int64;
begin
if (N = 2) or (N=3) then Result:=true
else if (n <= 1) or ((n mod 2) = 0) or ((n mod 3) = 0) then Result:= false
else
     begin
     I:=5;
     Stop:=Trunc(sqrt(N+0.0));
     Result:=False;
     while I<=Stop do
           begin
           if ((N mod I) = 0) or ((N mod (I + 2)) = 0) then exit;
           Inc(I,6);
           end;
     Result:=True;
     end;
end;


type TIntArray = array of integer;

type TNumList =  array [0..2, 0..4] of integer;

const NumLists: TNumList = (
  (5,45,23,21,67),
  (43,22,78,46,38),
  (9,98,12,98,53));


procedure GetColPrimes(NumList: TNumList; var ColPrimes: TIntArray);
{Get the Maxium value, find next prime and store result in array}
var X,Y,I,M: integer;
var Highest: integer;
begin
for X:=0 to High(NumLists[0]) do
  begin
        Highest:=0;
        for Y:=0 to High(NumList) do
             if NumLists[Y,X]>Highest then Highest:=NumList[Y,X];
  SetLength(ColPrimes,Length(ColPrimes)+1);
  ColPrimes[High(ColPrimes)]:=Highest;
  end;
for I:=0 to High(ColPrimes) do
  begin
  M:=ColPrimes[I];
  if (M mod 2)=0 then Inc(M);
  while not IsPrime(M) do Inc(M,2);
  ColPrimes[I]:=M;
  end;
end;



procedure ShowColumnPrimes(Memo: TMemo);
{Show min value for columns in NumLists}
var ColPrimes: TIntArray;
var I: integer;
var S: string;
begin
GetColPrimes(NumLists,ColPrimes);
S:='[';
for I:=0 to High(ColPrimes) do
  begin
  if I<>0 then S:=S+' ';
  S:=S+IntToStr(ColPrimes[I]);
  end;
S:=S+']';
Memo.Lines.Add(S);
end;


