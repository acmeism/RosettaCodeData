const TestStr: string =
'In  olden times when wishing still helped one, there lived a king whose '+
'daughters were all beautiful, but the youngest was so beautiful that the '+
'sun  itself, which has seen so much, was astonished whenever it shone in '+
'her  face. Close by the king''''s castle lay a great dark forest, and under '+
'an  old lime  tree in the  forest was a  well, and when the day was very '+
'warm, the king''''s child went out into the forest and sat down by the side '+
'of the cool fountain, and when she was bored she took a golden ball, and '+
'threw it up on high and caught it, and this ball was her favorite plaything.';


function ExtractToken(S: string; Sep: TASCIICharSet; var P: integer): string;
{Extract token from S, starting at P up to but not including Sep}
{Terminates with P pointing past Sep or past end of string}
var C: char;
begin
Result:='';
while P<=Length(S) do
	begin
	C:=S[P]; Inc(P);
	if C in Sep then break
	else Result:=Result+C;
	end;
end;



function WrapLines(S: string; WrapCol: integer): string;
{Returns S, with lines wrapped a specified column}
var Inx,J: integer;
var WordStr,LineStr: string;
begin
Result:='';
Inx:=1;
LineStr:='';
while true do
	begin
	{Grab next word}
	WordStr:=ExtractToken(S,[#$20,#$09,#$0D,#$0A],Inx);
	{Check to see if adding this word will exceed the column}
	if (Length(LineStr)+Length(WordStr))<WrapCol then
		begin
		{If not, add to current line}
		if Length(LineStr)>0 then LineStr:=LineStr+' ';
		LineStr:=LineStr+WordStr;
		end
	else
		begin
		{Save the line to the output string}
		Result:=Result+LineStr+CRLF;
		LineStr:=WordStr;
		end;
	if Inx>Length(S) then break;
	end;
if Length(LineStr)>0 then Result:=Result+LineStr;
end;


procedure DrawRuler(Memo: TMemo);
begin
Memo.Lines.Add('    5   10   15   20   25   30   35   40   45   50   55   60   65   70   75   80');
Memo.Lines.Add('----+----|----+----|----+----|----+----|----+----|----+----|----+----|----+----|');
end;


procedure ShowWordWrap(Memo: TMemo);
var S: string;
begin
DrawRuler(Memo);
S:=WrapLines(TestStr,60);
Memo.Lines.Add(S);

DrawRuler(Memo);
S:=WrapLines(TestStr,40);
Memo.Lines.Add(S);

DrawRuler(Memo);
S:=WrapLines(TestStr,20);
Memo.Lines.Add(S);
end;
