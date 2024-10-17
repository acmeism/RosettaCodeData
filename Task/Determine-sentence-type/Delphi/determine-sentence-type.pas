const TestStrings = 'hi there, how are you today? I''''d like to present to you the washing machine 9001. You have been nominated to win one of these! Just make sure you don''''t break it';

procedure AnalyzeSentenceType(Memo: TMemo; S: string);
{Extract sentences from string and analyze terminating punctuation}
var I: integer;
var Sent,SType: string;
begin
Sent:='';
for I:=1 to Length(S) do
	begin
	Sent:=Sent+S[I];
	{Look terminating char or condition}
	if (S[I] in ['?','!','.']) or (I>=Length(S)) then
		begin
		{If found, determine sentence type}
		case Sent[Length(Sent)] of
		 '?': SType:=' (Q)';
		 '!': SType:=' (E)';
		 '.': SType:=' (S)';
		 else SType:=' (N)';
		end;
		{Display it}
		Memo.Lines.Add(Trim(Sent)+SType);
		Sent:='';
		end;
	end;
end;


procedure TestSentenceTypes(Memo: TMemo);
{Analyze some test sentences}
begin
AnalyzeSentenceType(Memo, TestStrings);
end;
