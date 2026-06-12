const Power5: array [0..9] of integer = (0,1,32,243,1024,3125,7776,16807,32768,59049);

function SumFifthPower(N: integer): integer;
var S: string;
var I: integer;
begin
S:=IntToStr(N);
Result:=0;
for I:=1 to Length(S) do
  Result:=Result+Power5[byte(S[I])-$30];
end;

procedure ShowFiftPowerDigits(Memo: TMemo);
var I,Sum: integer;
begin
Sum:=0;
for I:=2 to 354424 do
	begin
	if I = SumFifthPower(I) then
		begin
		Memo.Lines.Add(Format('%8.0n',[I*1.0]));
		Sum:=Sum+I;
		end;
	end;
Memo.Lines.Add('========');
Memo.Lines.Add(Format('%8.0n',[Sum*1.0]));
end;

