function SplitStringCharChange(S: string): string;
{Split string whenever the previous char is different from the current one}
var I: integer;
var C: char;
begin
Result:='';
{Copy string to output}
for I:=1 to Length(S) do
	begin
	Result:=Result+S[I];
	{Appended ", " if the next char is different}
	if (I<Length(S)) and (S[I]<>S[I+1]) then Result:=Result+', ';
	end;
end;


procedure ShowSplitString(Memo: TMemo);
const S1 = 'gHHH5YY++///\';
var S2: string;
begin
Memo.Lines.Add(S1);
S2:=SplitStringCharChange(S1);
Memo.Lines.Add(S2);
end;
