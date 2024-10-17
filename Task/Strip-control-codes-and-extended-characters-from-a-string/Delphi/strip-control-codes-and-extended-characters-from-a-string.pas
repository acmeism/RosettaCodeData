{String pack with control and extened chars}

const TestStr ='N'+#$01 +'o'+#$02 +'w'+#$03 +' '+#$04 +'i'+#$05 +'s'+#$06 +' '+#$07 +'t'+#$08 +'h'+#$09 +'e'+#$0A +' '+#$0B +'t'+#$0C +'i'+#$0D +'m'+#$0E +'e'+#$0F +' '+#$10 +'f'+#$11 +'o'+#$12 +'r'+#$13 +' '+#$14 +'a'+#$15 +'l'+#$16 +'l'+#$17 +' '+#$18 +'g'+#$19 +'o'+#$1A +'o'+#$1B +'d'+#$1C +' '+#$1D +'m'+#$1E +'e'+#$1F +'n'+#$80 +' '+#$81 +'t'+#$82 +'o'+#$83 +' '+#$84 +'c'+#$85 +'o'+#$86 +'m'+#$87 +'e'+#$88 +' '+#$89 +'t'+#$8A +'o'+#$8B +' '+#$8C +'t'+#$8D +'h'+#$8E +'e'+#$8F +' '+#$90 +'a'+#$91 +'i'+#$92 +'d'+#$93 +' '+#$94 +'o'+#$95 +'f'+#$96 +' '+#$97 +'t'+#$98 +'h'+#$99 +'e'+#$9A +' '+#$9B +'p'+#$9C +'a'+#$9D +'r'+#$9E +'t'+#$9F +'y'+#$A0;

function StripControls(S: string): string;
{Strip control characters from string}
var I: integer;
begin
Result:='';
for I:=1 to Length(S) do
 if byte(S[I])>=$20 then Result:=Result+S[I];
end;

function StripExtended(S: string): string;
{Strip extended characters from string}
var I: integer;
begin
Result:='';
for I:=1 to Length(S) do
 if byte(S[I])<$80 then Result:=Result+S[I];
end;


procedure StripString(Memo: TMemo);
begin
Memo.Lines.Add('String full of controls and extended chars: ');
Memo.Lines.Add(TestStr);
Memo.Lines.Add('String stripped of controls chars: ');
Memo.Lines.Add(StripControls(TestStr));
Memo.Lines.Add('String stripped of extended chars: ');
Memo.Lines.Add(StripExtended(TestStr));
Memo.Lines.Add('String stripped of both control and extended chars: ');
Memo.Lines.Add(StripControls(StripExtended(TestStr)));
end;
