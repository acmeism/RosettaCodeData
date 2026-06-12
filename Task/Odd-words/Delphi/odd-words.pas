procedure ShowOddWords(Memo: TMemo);
var I,J: integer;
var W,S: string;
begin
{Iterate all entries in dictionary}
for I:=0 to UnixDict.Count-1 do
 if Length(UnixDict[I])>8 then	{Word must be >4, so every other is >8}
	begin
	W:=UnixDict[I];
	{Take every other letter}
	J:=1; S:='';
	while J<=Length(W) do
		begin
		S:=S+W[J];
		Inc(J,2);
		end;
	{Check if it is in Dictionary}
	if UnixDict.IndexOf(S)>0 then
		begin
		Memo.Lines.Add(W+' -> '+S);
		end;
	end;
end;

