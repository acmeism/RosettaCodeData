const TestStrings: array [0..7] of string = (
 'snakeCase', 'snake_case', 'variable_10_case', 'variable10Case',
 '\u025brgo rE tHis', 'hurry-up-joe!', 'c://my-docs/happy_Flag-Day/12.doc',
 '  spaces  ');


function MakeCamelCase(S: string): string;
{Convert string to camel-case}
var I: integer;
var Toggle: boolean;
begin
S:=Trim(S);
Result:='';
for I:=1 to Length(S) do
 if Toggle then
	begin
	Result:=Result+UpperCase(S[I]);
	Toggle:=False;
	end
 else if S[I] in [' ','_','-'] then Toggle:=True
 else Result:=Result+S[I];
end;


function MakeSnakeCase(S: string): string;
{Convert string to snake-case}
var I: integer;
var Toggle: boolean;
begin
S:=Trim(S);
Result:='';
for I:=1 to Length(S) do
 if S[I] in [' ','-'] then Result:=Result+'_'
 else if S[I] in ['A'..'Z'] then
	begin
	Result:=Result+'_';
	Result:=Result+LowerCase(S[I]);
	end
 else Result:=Result+S[I];
end;

procedure ConvertCamelSnake(SA: array of string; Memo: TMemo);
var I: integer;
var S: string;

	function FormatStrs(S1,S2: string): string;
	begin
	Result:=Format('%35s',[S1])+' '+Format('%-35s',[S2]);
	end;

begin
Memo.Lines.Add('Snake Case: ');
for I:=0 to High(SA) do
	begin
	S:=FormatStrs(SA[I],MakeSnakeCase(SA[I]));
	Memo.Lines.Add(S);
	end;
Memo.Lines.Add('Camel Case: ');
for I:=0 to High(SA) do
	begin
	S:=FormatStrs(SA[I],MakeCamelCase(SA[I]));
	Memo.Lines.Add(S);
	end;
end;

procedure CamelSnakeTest(Memo: TMemo);
{Test camel/snake conversion routines}
begin
ConvertCamelSnake(TestStrings,Memo);
end;
