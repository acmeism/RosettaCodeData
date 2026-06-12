var Dict: TStringList;	{List holds dictionary}


procedure DoChangeWords(Memo: TMemo);
{Do change word problem}
var I,J,K,Inx,Cnt: integer;
var S: string;

	procedure Display(OldStr,NewStr: string);
	{Display both the original word and the modified word}
	begin
	Inc(Cnt);
	Memo.Lines.Add(IntToStr(Cnt)+': '+OldStr+' '+NewStr);
	end;

begin
Cnt:=0;
{Check every word in the dictionary}
for I:=0 to Dict.Count-1 do
	begin
	{Only check words at least 12 chars long}
	if Length(Dict[I])>=12 then
		begin
		{Test a specific position in the word}
		for J:=1 to Length(Dict[I]) do
			begin
			{try all combinations of alpha chars in the position}
			for K:=byte('a') to byte('z') do
				begin
				{skip if the char is already in the position}
				if Dict[I][J]=char(K) then continue;
				{Get a new copy of the word to modify}
				S:=Dict[I];
				{Modify the position}
				S[J]:=char(K);
				{Is it in the dictionary? }
				Inx:=Dict.IndexOf(S);
				{Display it if it is}
				if Inx>=0 then Display(Dict[I],S);
				end;
			end;
		end;
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
