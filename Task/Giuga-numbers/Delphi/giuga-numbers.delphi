function IsGiugaNumber(N: integer): boolean;
var IA: TIntegerDynArray;
var I,V: integer;
begin
Result:=False;
if IsPrime(N) then exit;
GetPrimeFactors(N,IA);
for I:=0 to High(IA) do
	begin
	V:=N div IA[I] - 1;
	if (V mod IA[I])<>0 then exit;
	end;
Result:=True;
end;

procedure ShowGiugaNumbers(Memo: TMemo);
var I,Cnt: integer;
begin
Cnt:=0;
for I:=4 to High(integer) do
if IsGiugaNumber(I) then
	begin
	Inc(Cnt);
	Memo.Lines.Add(IntToStr(I));
	if Cnt>=4 then break;
	end;
end;
