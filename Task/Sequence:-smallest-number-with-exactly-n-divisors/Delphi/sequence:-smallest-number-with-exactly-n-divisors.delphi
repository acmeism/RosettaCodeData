{This code would normally be in a separate library. It is provided for clarity}

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


{-------------------------------------------------------------------------------}

procedure SequenceWithNdivisors(Memo: TMemo);
var N,N2: integer;
var IA: TIntegerDynArray;
begin
for N:=1 to 15 do
	begin
	N2:=0;
	repeat Inc(N2) until N=GetAllDivisors(N2,IA);
	Memo.Lines.Add(IntToStr(N)+' - '+IntToStr(N2));
	end;
end;
