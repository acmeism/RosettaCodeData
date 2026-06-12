var Dict: TStringList;	{List holds dictionary}


procedure FindFirst3Last3Match(Memo: TMemo);
{Find words where the first and last 3 characters are identical}
var I: integer;
var First3,Last3: string;
begin
for I:=0 to Dict.Count-1 do
 if Length(Dict[I])>5 then
	begin
	First3:=Copy(Dict[I],1,3);
	Last3:=Copy(Dict[I],Length(Dict[I])-2,3);
	if First3=Last3 then
		begin
		Memo.Lines.Add(Dict[I]);
		end
	end;
end;


initialization
{Create/load dictionary}
Dict:=TStringList.Create;
Dict.LoadFromFile('unixdict.txt');
Dict.Sorted:=True;
finalization
Dict.Free;
end.

