function SortStringLetters(S: string): string;
{Extract letters from string and sort them}
{Uses string list component to hold and sort chars}
var SL: TStringList;
var I: integer;
begin
SL:=TStringList.Create;
try
for I:=1 to Length(S) do SL.Add(S[I]);
SL.Sort;
SetLength(Result,SL.Count);
for I:=0 to SL.Count-1 do
 Result[I+1]:=SL[I][1];
finally SL.Free; end;
end;

const S1 = 'Now is the time for all good men to come to the aid of the party.';
const S2 = 'See the quick brown fox jump over the lazy dog.';

procedure ShowSortedLetters(Memo: TMemo);
var S: string;
begin
Memo.Lines.Add('Unsorted = '+S1);
Memo.Lines.Add('Sorted = '+SortStringLetters(S1));
Memo.Lines.Add('Unsorted = '+S2);
Memo.Lines.Add('Sorted = '+SortStringLetters(S2));
end;

