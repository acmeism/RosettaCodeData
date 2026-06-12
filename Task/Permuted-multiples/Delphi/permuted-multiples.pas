function IsPMultiple(N: integer): boolean;
{Test if N*2, N*3, N*4, N*5, N*6 have the same digits}
var NT: integer;
var SA: array [0..4] of string;
var I,J: integer;
var SL: TStringList;
var IA: TIntegerDynArray;
begin
SL:=TStringList.Create;
try
Result:=False;
for I:=0 to 4 do
	begin
	{Do N*2, N*3, N*4, N*5, N*6}
	NT:=N * (I+2);
	{Get digits}
	GetDigits(NT,IA);
	{Store each digit in String List}
	SL.Clear;
	for J:=0 to High(IA) do SL.Add(IntToStr(IA[J]));
	{Sort list}
	SL.Sort;
	{Put sorted digits in a string}
	SA[I]:='';
	for J:=0 to SL.Count-1 do SA[I]:=SA[I]+SL[J][1];
	end;
{Compare all strings}
for I:=0 to High(SA)-1 do
 if SA[I]<>SA[I+1] then exit;
Result:=True;
finally SL.Free; end;
end;

procedure ShowPermutedMultiples(Memo: TMemo);
var I,J: integer;
begin
for I:=1 to high(integer) do
 if IsPMultiple(I) then
	begin
	for J:=1 to 6 do
	  Memo.Lines.Add(Format('N * %D = %D',[J,I*J]));
	break;
	end;
end;


