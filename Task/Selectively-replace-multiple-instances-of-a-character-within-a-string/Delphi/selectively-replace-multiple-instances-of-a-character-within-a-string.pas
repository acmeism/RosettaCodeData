var TestStr: string = 'abracadabra';


function FindNthChar(C: char; S: string; N: integer): integer;
{Routine to find the Nth version of C, string S}
begin
for Result:=1 to Length(S) do
 if S[Result]=C then
	begin
	Dec(N);
	if N<=0 then exit;
	end;
Result:=-1;
end;


procedure ReplaceNthChar(COld,CNew: char; var S: string; N: integer);
{Find and replace the Nth version COld with CNew}
var Inx: integer;
begin
Inx:=FindNthChar(COld,S,N);
if Inx<1 then exit;
S[Inx]:=CNew;
end;


procedure SelectivelyReplaceChars(Memo: TMemo);
var I: integer;
begin
Memo.Lines.Add('Before: '+TestStr);
{Do the replacement toward the end of string first}
ReplaceNthChar('a','D',TestStr,5);
ReplaceNthChar('a','C',TestStr,4);
ReplaceNthChar('a','B',TestStr,2);
ReplaceNthChar('r','F',TestStr,2);
ReplaceNthChar('a','A',TestStr,1);
ReplaceNthChar('b','E',TestStr,1);
Memo.Lines.Add('After: '+TestStr);
end;
