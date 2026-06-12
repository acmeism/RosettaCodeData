{These subroutines would normally be in a library, but they are shown here for clarity.}


function GetAllProperDivisors(N: Integer;var IA: TIntegerDynArray): integer;
{Make a list of all the "proper dividers" for N}
{Proper dividers are the of numbers the divide evenly into N}
var I: integer;
begin
SetLength(IA,0);
for I:=1 to N-1 do
 if (N mod I)=0 then
	begin
	SetLength(IA,Length(IA)+1);
	IA[High(IA)]:=I;
	end;
Result:=Length(IA);
end;


function GetAllDivisors(N: Integer;var IA: TIntegerDynArray): integer;
{Make a list of all the "proper dividers" for N, Plus N itself}
begin
Result:=GetAllProperDivisors(N,IA)+1;
SetLength(IA,Length(IA)+1);
IA[High(IA)]:=N;
end;



procedure ProductOfDivisors(Memo: TMemo);
var I,J,P: integer;
var IA: TIntegerDynArray;
var S: string;
begin
S:='';
for I:=1 to 50 do
	begin
	GetAllDivisors(I,IA);
	P:=1;
	for J:=0 to High(IA) do P:=P * IA[J];
	S:=S+Format('%12D',[P]);
	If (I mod 5)=0 then S:=S+CRLF;
	 end;
Memo.Lines.Add(S);
end;

