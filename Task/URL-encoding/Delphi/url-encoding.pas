function EncodeURL(URL: string): string;
var I: integer;
begin
Result:='';
for I:=1 to Length(URL) do
 if URL[I] in ['0'..'9', 'A'..'Z', 'a'..'z'] then Result:=Result+URL[I]
 else Result:=Result+'%'+IntToHex(byte(URL[I]),2);
end;

procedure EncodeAndShowURL(Memo: TMemo; URL: string);
var ES: string;
begin
Memo.Lines.Add('Unencoded URL: '+URL);
ES:=EncodeURL(URL);
Memo.Lines.Add('Encoded URL:   '+ES);
Memo.Lines.Add('');
end;

procedure ShowEncodedURLs(Memo: TMemo);
begin
EncodeAndShowURL(Memo,'http://foo bar/');
EncodeAndShowURL(Memo,'https://rosettacode.org/wiki/URL_encoding');
EncodeAndShowURL(Memo,'https://en.wikipedia.org/wiki/Pikes_Peak_granite');
end;
