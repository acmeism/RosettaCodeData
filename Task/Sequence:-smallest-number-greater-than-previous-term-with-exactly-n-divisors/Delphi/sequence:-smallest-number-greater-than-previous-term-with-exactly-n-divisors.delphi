{These routines would normally be in a library, but the shown here for clarity}

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


procedure SmallestWithNDivisors(Memo: TMemo);
var N,Count: integer;
var IA: TIntegerDynArray;
begin
Count:=1;
for N:=1 to high(Integer) do
 if Count=GetAllDivisors(N,IA) then
	begin
	Memo.Lines.Add(IntToStr(Count)+' - '+IntToStr(N));
	Inc(Count);
	if Count>15 then break;
	end;
end;
