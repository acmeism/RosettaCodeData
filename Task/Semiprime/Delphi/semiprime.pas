{This function would normally be in a library, but it shown here for clarity}

procedure GetAllFactors(N: Integer;var IA: TIntegerDynArray);
{Make a list of all irreducible factor of N}
var I: integer;
begin
SetLength(IA,1);
IA[0]:=1;
for I:=2 to N do
 while (N mod I)=0 do
	begin
	SetLength(IA,Length(IA)+1);
	IA[High(IA)]:=I;
	N:=N div I;
	end;
end;


function IsSemiprime(N: integer): boolean;
{Test if number is semiprime}
var IA: TIntegerDynArray;
begin
{Get all factors of N}
GetAllFactors(N,IA);
Result:=False;
{Since 1 is factor, ignore it}
if Length(IA)<>3 then exit;
Result:=IsPrime(IA[1]) and IsPrime(IA[2]);
end;


procedure Semiprimes(Memo: TMemo);
var I,Cnt: integer;
var S: string;
begin
Cnt:=0;
S:='';
{Test first 100 number to see if they are semiprime}
for I:=0 to 100-1 do
 if IsSemiprime(I) then
	begin
	Inc(Cnt);
	S:=S+Format('%4d',[I]);
	if (Cnt mod 10)= 0 then S:=S+CRLF;
	end;
Memo.Lines.Add(S);
Memo.Lines.Add('Count='+IntToStr(Cnt));
end;
