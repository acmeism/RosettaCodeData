var SA1: array [0..1] of string = ('Very Long String','short string');
var SA2: array [0..11] of string = ('Like','sands','through','the','hourglass',
				   'these','are','the','days','of','our','lives');

function Compare(P1,P2: pointer): integer;
{Compare for quick sort}
begin
Result:=Length(PString(P2)^)-Length(PString(P1)^);
end;


procedure ShowStringLengths(SA: array of string; Memo: TMemo);
{Sort strings by length and display string and length}
var List: TList;
var I: integer;
var S: string;
begin
List:=TList.Create;
try
for I:=0 to High(SA) do
 List.Add(@SA[I]);
List.Sort(Compare);
for I:=0 to List.Count-1 do
	begin
	S:=PString(List[I])^;
	Memo.Lines.Add(IntToStr(Length(S))+': '+S);
	end;
finally List.Free; end;
end;


procedure SortedStringLists(Memo: TMemo);
{Test two different string arrays}
begin
Memo.Lines.Add('Two word test: ');
Memo.Lines.Add('');
ShowStringLengths(SA1,Memo);
Memo.Lines.Add('');
Memo.Lines.Add('Twelve word test: ');
Memo.Lines.Add('');
ShowStringLengths(SA2,Memo);
end;
