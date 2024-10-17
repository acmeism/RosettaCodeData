function WaitForString(Memo: TMemo; Prompt: string): string;
{Wait for key stroke on TMemo component}
var KW: TKeyWaiter;
begin
{Use custom object to wait and capture key strokes}
KW:=TKeyWaiter.Create(Memo);
try
Memo.Lines.Add(Prompt);
Memo.SelStart:=Memo.SelStart-1;
Memo.SetFocus;
Result:=KW.WaitForString;
finally KW.Free; end;
end;


procedure NameGame(Memo: TMemo);
var Name: string;
var Str2: string;
var FL: Char;

	function GetPattern: string;
	var BStr,FStr,MStr: string;
	begin
	if FL='b' then BStr:='bo-' else BStr:='bo-b';
	if FL='f' then FStr:='fo-' else FStr:='fo-f';
	if FL='m' then MStr:='mo-' else MStr:='mo-m';
	Result:=Format('%S, %S, %S%S',[Name,Name,BStr,Str2])+CRLF;
	Result:=Result+Format('Banana-fana %S%S',[FStr,Str2])+CRLF;
	Result:=Result+Format('Fee-fi-%S%S',[MStr,Str2])+CRLF;
	Result:=Result+Format('%S!',[Name])+CRLF;
	end;

begin
while true do
	begin
	Name:=WaitForString(Memo,'Enter a name: ');
	if Name='' then break;
	Str2:=LowerCase(Name);
	FL:=Str2[1];
	if not (FL in ['a','e','i','o','u']) then Delete(Str2,1,1);

	Memo.Lines.Add(GetPattern);
	end;
end;
