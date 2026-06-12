var Dict: TStringList;	{List holds dictionary}

function IsVowel(C: char): boolean;
begin
Result:=C in ['a','e','i','o','u'];
end;

function DoesAlternate(S: string): boolean;
var I: integer;
var Vowel: boolean;
begin
Result:=False;
Vowel:=IsVowel(S[1]);
for I:=2 to Length(S) do
	begin
	if not (Vowel xor IsVowel(S[I])) then exit;
	Vowel:=IsVowel(S[I]);
	end;
Result:=True;
end;


procedure AlternateVowelConsonant(Memo: TMemo);
{Find words where the letters alternate vowel,consonant}
var I,Cnt: integer;
var S: string;
begin
S:=''; Cnt:=0;
for I:=0 to Dict.Count-1 do
 if Length(Dict[I])>9 then
	begin
	if DoesAlternate(Dict[I]) then
		begin
		Inc(Cnt);
		S:=S+Format('%-23s',[Dict[I]]);
		if (Cnt mod 4)=0 then S:=S+#$0D#$0A
		end
	end;
Memo.Lines.Add(IntToStr(Cnt)+' Alternate Vowel/Consonant words found.');
Memo.Lines.Add(S);
end;


initialization
{Create/load dictionary}
Dict:=TStringList.Create;
Dict.LoadFromFile('unixdict.txt');
Dict.Sorted:=True;
finalization
Dict.Free;
end.

