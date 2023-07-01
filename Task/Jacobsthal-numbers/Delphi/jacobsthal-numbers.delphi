procedure GetJacobsthalNum(Lucas: boolean; Max: integer; var IA: TInt64DynArray);
{Get Jacobsthal number sequence. If Lucas is true do Lucal variation}
var I: integer;
begin
SetLength(IA,Max);
{Lucas starts sequence with 2 instead of 0}
if Lucas then IA[0]:=2 else IA[0]:=0;
IA[1]:=1;
{Calculate Nn = Nn-1 + 2 Nn-2}
for I:=2 to Max-1 do
  IA[I]:=IA[I-1] + 2 * IA[I-2];
end;


procedure GetJacobsthalOblong(Max: integer; var IA: TInt64DynArray);
{Jacobsthal Oblong numbers is Nn = Jn x Jn=1 where J = Jacobsthal numbers}
var IA2: TInt64DynArray;
var I: integer;
begin
GetJacobsthalNum(False,Max+1,IA2);
SetLength(IA,Max);
for I:=0 to High(IA2)-1 do
	begin
	IA[I]:=IA2[I] * IA2[I+1];
	end;
end;


procedure GetJacobsthalPrimes(Memo: TMemo);
var I: integer;
var Jacob,N1, N2: int64;

	function GetNext: int64;
	{Nn = Nn-1 + 2 x Nn-2}
	begin
	Result:=N1 + 2 * N2;
	N2:=N1; N1:=Result;
	end;

begin
N2:=0; N1:=1;
for I:=1 to 10 do
	begin
	repeat Jacob:=GetNext;
	until IsPrime(Jacob);
	Memo.Lines.Add(IntToStr(I)+' - '+IntToStr(Jacob));
	end;
end;



procedure ShowJacobsthalNumbers(Memo: TMemo);
var I: integer;
var IA: TInt64DynArray;
var S: string;
begin
GetJacobsthalNum(False,30,IA);
Memo.Lines.Add('First 30 Jacobsthal Numbers');
S:='';
for I:=0 to High(IA) do
	begin
	S:=S+Format('%12.0n',[IA[I]+0.0]);
	if (I mod 5)=4 then S:=S+CRLF;
	end;
Memo.Lines.Add(S);

Memo.Lines.Add('');
GetJacobsthalNum(True,30,IA);
Memo.Lines.Add('First 30 Jacobsthal-Lucas Numbers');
S:='';
for I:=0 to High(IA) do
	begin
	S:=S+Format('%14.0n',[IA[I]+0.0]);
	if (I mod 4)=3 then S:=S+CRLF;
	end;
Memo.Lines.Add(S);

Memo.Lines.Add('');
GetJacobsthalOblong(20,IA);
Memo.Lines.Add('First 20 Jacobsthal-Oblong Numbers');
S:='';
for I:=0 to High(IA) do
	begin
	S:=S+Format('%18.0n',[IA[I]+0.0]);
	if (I mod 3)=2 then S:=S+CRLF;
	end;
Memo.Lines.Add(S);

Memo.Lines.Add('');
GetJacobsthalPrimes(Memo);
end;
