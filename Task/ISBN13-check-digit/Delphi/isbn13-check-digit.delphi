function ValidateISBN(ISBN: string): boolean;
{Validate an ISBN number}
var I,N,Sum: integer;
begin
Sum:=0;
{Go througha chars, ignoring non-digits}
for I:=1 to Length(ISBN) do
 if ISBN[I] in ['0'..'9'] then
	begin
	N:=StrToInt(ISBN[I]);
	{Every other digit multiplied by 3}
	if (I and 1)=1 then N:=N*3;
	{Sum digits}
	Sum:=Sum+N;
	end;
{The sum must be an even multiple of 10}
Result:=(Sum mod 10)=0;
end;

procedure ValidateAndShow(Memo: TMemo; ISBN: string);
{Validate ISBN number and show the result}
var S: string;
begin
S:=ISBN;
if ValidateISBN(ISBN) then S:=S+' (Good)'
else S:=S+' (Bad)';
Memo.Lines.Add(S);
end;

procedure TestISBNSet(Memo: TMemo);
{Test supplied set of ISBN numbers}
begin
ValidateAndShow(Memo,'978-0596528126');		//(good)
ValidateAndShow(Memo,'978-0596528120');		//(bad)
ValidateAndShow(Memo,'978-1788399081');		//(good)
ValidateAndShow(Memo,'978-1788399083');		//(bad)
end;
