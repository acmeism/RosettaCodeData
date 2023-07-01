function UpperAlphaOnly(S: string): string;
{Remove all }
var I: integer;
begin
Result:='';
S:=UpperCase(S);
for I:=1 to Length(S) do
if S[I] in ['A'..'Z'] then Result:=Result+S[I];
end;


function VigenereEncrypt(Text, Key: string): string;
{Encrypt Text using specified key}
var KInx,TInx,I: integer;
var TC: byte;
begin
Result:='';
{Force Text and Key upper case}
Text:=UpperAlphaOnly(Text);
Key:=UpperAlphaOnly(Key);
{Point to first Key-character}
KInx:=1;
for I:=1 to Length(Text) do
	begin
	{Offset Text-char by key-char amount}
	TC:=byte(Text[I])-byte('A')+Byte(Key[KInx]);
	{if it is shifted past "Z", wrap back around past "A"}
	if TC>Byte('Z') then TC:=byte('@')+(TC-Byte('Z'));
	{Store in output string}
	Result:=Result+Char(TC);
	{Point to next Key-char}
	Inc(Kinx);
	{If index post end of key, start over}
	if KInx>Length(Key) then KInx:=1;
	end;
end;


function VigenereDecrypt(Text, Key: string): string;
{Encrypt Text using specified key}
var KInx,TInx,I: integer;
var TC: byte;
begin
Result:='';
{For Key and text uppercase}
Text:=UpperAlphaOnly(Text);
Key:=UpperAlphaOnly(Key);
KInx:=1;
for I:=1 to Length(Text) do
	begin
	{subtrack key-char from text-char}
	TC:=byte(Text[I])-Byte(Key[Kinx])+Byte('A');
	{if result below "A" wrap back around to "Z"}
	if TC<Byte('A') then TC:=(byte('Z')-((Byte('A')-TC)))+1;
	{store in result}
	Result:=Result+Char(TC);
	{Point to next key char}
	Inc(Kinx);
	{Past the end, start over}
	if KInx>Length(Key) then KInx:=1;
	end;
end;

const TestKey = 'VIGENERECIPHER';
const TestStr = 'Beware the Jabberwock, my son! The jaws that bite, the claws that catch!';


procedure VigenereCipher(Memo: TMemo);
var S: string;
begin
{Show plain text}
Memo.Lines.Add(TestStr);
S:=VigenereEncrypt(TestStr, TestKey);
{Show encrypted text}
Memo.Lines.Add(S);
S:=VigenereDecrypt(S, TestKey);
{Show decrypted text}
Memo.Lines.Add(S);
end;
