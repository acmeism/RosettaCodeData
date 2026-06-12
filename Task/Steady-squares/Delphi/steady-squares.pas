{This routine is normally part of a separate library, but it is included here for clarity}

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



function IsSteadySquare(N: integer): boolean;
{compare digits of N and N^2 and see if they matchs}
var Dig1,Dig2: TIntegerDynArray;
var I: integer;
begin
Result:=False;
{Get digits}
GetDigits(N,Dig1);
GetDigits(N*N,Dig2);
{Compare digits}
for I:=0 to High(Dig1) do
 if Dig1[I]<>Dig2[I] then exit;
Result:=True
end;


procedure ShowSteadySquares(Memo: TMemo);
var I: integer;
begin
for I:=1 to 10000-1 do
 if IsSteadySquare(I) then
 Memo.Lines.Add(Format('%6.0n^2 = %10.0n',[I+0.0,I*I+0.0]));
end;


