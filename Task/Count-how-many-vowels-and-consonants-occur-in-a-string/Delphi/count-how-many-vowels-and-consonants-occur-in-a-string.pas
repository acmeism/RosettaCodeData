const TestStr1: string = 'Delphi is delightful.';
const TestStr2: string = 'Now is the time for all good men to come to the aid of their country.';


type TCharSet = set of 'a'..'z';

procedure VowelConsonant(S: string; Memo: TMemo);
{Find number of total and unique vowels and consonants}
const Vows: TCharSet = ['a','e','i','o','u'];
const Cons: TCharSet = ['a'..'z']-['a','e','i','o','u'];
var VowSet,ConSet: TCharSet;
var VCnt,CCnt,UVCnt,UCCnt,I: integer;

	procedure HandleMatch(C: char; var Cnt,UCnt: integer; var CSet: TCharSet);
	{Handle set matching and incrementing operations}
	begin
	Inc(Cnt);
	if not (C in CSet) then Inc(UCnt);
	Include(CSet,C);
	end;

begin
Memo.Lines.Add(S);
VCnt:=0; CCnt:=0;
UVCnt:=0;UCCnt:=0;
S:=LowerCase(S);
for I:=1 to Length(S) do
	begin
	{Test if character is vowel or consonant}
	if S[I] in Vows then HandleMatch(S[I],VCnt,UVCnt,VowSet)
	else if S[I] in Cons then HandleMatch(S[I],CCnt,UCCnt,ConSet);
	end;

Memo.Lines.Add('Vowels: '+IntToStr(VCnt));
Memo.Lines.Add('Consonants: '+IntToStr(CCnt));
Memo.Lines.Add('Unique Vowels: '+IntToStr(UVCnt));
Memo.Lines.Add('Unique Consonants: '+IntToStr(UCCnt));
end;


procedure DoVowelConsonantTest(Memo: TMemo);
{Test two strings for vowels/consonants}
begin
VowelConsonant(TestStr1,Memo);
Memo.Lines.Add('');
VowelConsonant(TestStr2,Memo);
end;


