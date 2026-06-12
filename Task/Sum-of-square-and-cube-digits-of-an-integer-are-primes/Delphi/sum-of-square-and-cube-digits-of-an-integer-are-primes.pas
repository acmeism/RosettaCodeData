procedure GetDigits(N: integer; var IA: TIntegerDynArray);
{Get an array of the integers in a number}
{Numbers returned from least to most significant}
var T,I,DC: integer;
begin
DC:=Trunc(Log10(N))+1;
SetLength(IA,DC);
for I:=0 to DC-1 do
	begin
	T:=N mod 10;
	N:=N div 10;
	IA[I]:=T;
	end;
end;


procedure SquareCubeDigitsPrime(Memo: TMemo);
var Dg1,Dg2: TIntegerDynArray;
var SQ,CU: integer;
var Sum1,Sum2: integer;
var I,J: integer;
var S: string;
begin
S:='';
for I:=1 to 100-1 do
	begin
	SQ:=I*I;
	CU:=I*I*I;
	GetDigits(SQ,Dg1);
	GetDigits(CU,Dg2);
	Sum1:=0;
	for J:=0 to High(Dg1) do Sum1:=Sum1+Dg1[J];
	Sum2:=0;
	for J:=0 to High(Dg2) do Sum2:=Sum2+Dg2[J];
	if IsPrime(Sum1) and IsPrime(Sum2) then
		S:=S+' '+IntToStr(I);
	end;
Memo.Lines.Add(S);
end;



