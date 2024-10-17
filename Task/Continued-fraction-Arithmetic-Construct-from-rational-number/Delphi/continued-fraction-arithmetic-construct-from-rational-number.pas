function GetNextFraction(var N1,N2: integer): integer;
{Get next step in fraction series}
var R: integer;
begin
R:=FloorMod(N1, N2);
Result:= FloorDiv(N1 - R , N2);
N1 := N2;
N2 := R;
end;

procedure GetFractionList(N1,N2: integer; var IA: TIntegerDynArray);
{Get list of continuous fraction values}
var M1, M2,F : integer;
var S: integer;
begin
SetLength(IA,0);
M1 := N1;
M2 := N2;
while M2<>0 do
	begin
	F:=GetNextFraction(M1,M2);
	SetLength(IA,Length(IA)+1);
	IA[High(IA)]:=F;
	end;
end;


procedure ShowConFraction(Memo: TMemo; N1,N2: integer);
{Calculate and display continues fraction for Rational number N1/N2}
var I: integer;
var S: string;
var IA: TIntegerDynArray;
begin
GetFractionList(N1,N2,IA);
S:='[';
for I:=0 to High(IA) do
	begin
	if I>0 then S:=S+', ';
	S:=S+IntToStr(IA[I]);
	end;
S:=S+']';
Memo.Lines.Add(Format('%10d / %10d --> ',[N1,N2])+S);
end;


procedure ShowContinuedFractions(Memo: TMemo);
{Show all continued fraction tests}
begin
Memo.Lines.Add('Wikipedia Example');
ShowConFraction(Memo,415,93);

Memo.Lines.Add('');
Memo.Lines.Add('Rosetta Code Examples');
ShowConFraction(Memo,1, 2);
ShowConFraction(Memo,3, 1);
ShowConFraction(Memo,23, 8);
ShowConFraction(Memo,13, 11);
ShowConFraction(Memo,22, 7);
ShowConFraction(Memo,-151, 77);


Memo.Lines.Add('');
Memo.Lines.Add('Square Root of Two');
ShowConFraction(Memo,14142, 10000);
ShowConFraction(Memo,141421, 100000);
ShowConFraction(Memo,1414214, 1000000);
ShowConFraction(Memo,14142136, 10000000);

Memo.Lines.Add('');
Memo.Lines.Add('PI');
ShowConFraction(Memo,31, 10);
ShowConFraction(Memo,314, 100);
ShowConFraction(Memo,3142, 1000);
ShowConFraction(Memo,31428, 10000);
ShowConFraction(Memo,314285, 100000);
ShowConFraction(Memo,3142857, 1000000);
ShowConFraction(Memo,31428571, 10000000);
ShowConFraction(Memo,314285714, 100000000);
end;
