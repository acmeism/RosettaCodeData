var Dict: TStringList;	{List holds dictionary}

function HasEVowels(S: string): boolean;
{Test if string has exclusively E-Vowels and no "a,i,o,u"}
var I,ECount: integer;
begin
Result:=False;
ECount:=0;
for I:=1 to Length(S) do
	begin
	if S[I] in ['a','i','o','u'] then exit;
	if S[I]='e' then Inc(ECount);
	end;
Result:=ECount>3;
end;


procedure ShowEVowels(Memo: TMemo);
{Show words in dictionary that only}
{have e-vowels and have at least three}
var I: integer;
var SL: TStringList;
var S: string;
begin
SL:=TStringList.Create;
try
{Make list of words with least three E-vowels}
for I:=0 to Dict.Count-1 do
 if HasEVowels(Dict[I]) then SL.Add(Dict[I]);
{Display all the words found}
S:='Found: '+IntToStr(SL.Count)+#$0D#$0A;
for I:=0 to SL.Count-1 do
	begin
	S:=S+Format('%-23s',[SL[I]]);
	if (I mod 4)=3 then S:=S+#$0D#$0A;
	end;
Memo.Text:=S;
finally SL.Free; end;
end;



initialization
{Create/load dictionary}
Dict:=TStringList.Create;
Dict.LoadFromFile('unixdict.txt');
Dict.Sorted:=True;
finalization
Dict.Free;
end.

