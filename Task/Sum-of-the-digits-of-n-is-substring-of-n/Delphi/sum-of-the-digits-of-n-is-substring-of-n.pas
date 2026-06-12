{This code would normally be in a library, but is included here for clarity}

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


procedure SumDigitsSubstring(Memo: TMemo);
var N,J,Cnt,Sum: integer;
var Dg: TIntegerDynArray;
var NS,SS,S: string;
begin
S:='';
Cnt:=0;
for N:=0 to 1000-1 do
	begin
	GetDigits(N,Dg);
	Sum:=0;
	for J:=0 to High(Dg) do
	  Sum:=Sum+Dg[J];
	NS:=IntToStr(N);
	SS:=IntToStr(Sum);
	if Pos(SS,NS)>0 then
		begin
		Inc(Cnt);
		S:=S+Format('%4d',[N]);
		if (Cnt mod 10)=0 then S:=S+CRLF;
		end;
	end;
Memo.Lines.Add(S);
end;



