function InputByRadix(S: string; Radix: integer): integer;
{Coverts the input string of the specified radix to an integer}
{Accepts digits in the range 0..9 and A..Z and ignores anything else}
var I,B: integer;
begin
Result:=0;
S:=UpperCase(S);
for I:=1 to Length(S) do
	begin
	if S[I] in ['0'..'9'] then B:=byte(S[I])-$30
	else if S[I] in ['A'..'Z'] then B:=byte(S[I])-$41;
	Result:=Result * Radix + B;
	end;
end;

procedure ShowRadixInput(Memo: TMemo);
var Base,I: integer;
begin
for Base:=2 to 20 do
	begin
	I:=InputByRadix('100',Base);
	Memo.Lines.Add(Format('String "100" in base %2D is %3D in Base 10',[Base,I]));
	end;
end;
