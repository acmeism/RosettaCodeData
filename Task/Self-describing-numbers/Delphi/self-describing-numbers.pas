{This routine would normally be in a library. It is shown here for clarity.}


procedure GetDigitsRev(N: integer; var IA: TIntegerDynArray);
{Get an array of the integers in a number}
{Numbers returned from most to least significant}
var T,I,DC: integer;
begin
DC:=Trunc(Log10(N))+1;
SetLength(IA,DC);
for I:=DC-1 downto 0 do
	begin
	T:=N mod 10;
	N:=N div 10;
	IA[I]:=T;
	end;
end;



function IsSelfDescribing(N: integer): boolean;
var IA: TIntegerDynArray;
var CA: array [0..9] of integer;
var I: integer;
begin
{Get digits, High-low order}
GetDigitsRev(N,IA);
for I:=0 to High(CA) do CA[I]:=0;
{Count number of each digit 0..9}
for I:=0 to High(IA) do
	begin
	CA[IA[I]]:=CA[IA[I]]+1;
	end;
Result:=False;
{Compare original number with counts}
for I:=0 to High(IA) do
 if IA[I]<>CA[I] then exit;
Result:=True;
end;


procedure SelfDescribingNumbers(Memo: TMemo);
var I: integer;
begin
for I:=0 to 100000000-1 do
 if IsSelfDescribing(I) then
	begin
	Memo.Lines.Add(IntToStr(I));
	end;
end;
