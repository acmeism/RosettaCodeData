function HarmonicNumber(N: integer): double;
{Calculate sum of }
var I: integer;
begin
Result:=0;
for I:=1 to N do Result:=Result+1/I;
end;



function FirstHarmonicOver(Limit: integer): integer;
{Find first harmonic number over limit}
var HN: double;
begin
for Result:=1 to high(Integer) do
	begin
	HN:=HarmonicNumber(Result);
	if HN>Limit then exit;
	end
end;


procedure ShowHarmonicNumbers(Memo: TMemo);
var I,Inx: integer;
var HN: double;
begin
{Show first 20 harmonic numbers}
for I:=1 to 20 do
	begin
	HN:=HarmonicNumber(I);
	Memo.Lines.Add(Format('%2D: %8.8f',[I,HN]));
	end;
{Show the position of the number that exceeds 1..10 }
for I:=1 to 10 do
	begin
	Inx:=FirstHarmonicOver(I);
        Memo.Lines.Add(Format('Position of the first harmonic number >  %2D: %4D',[I,Inx]))
	end;
end;
