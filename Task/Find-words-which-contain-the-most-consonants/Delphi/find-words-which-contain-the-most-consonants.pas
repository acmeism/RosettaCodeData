var Dict: TStringList;	{List holds dictionary}


function CountConsonants(S: string): integer;
{Count the number of unique consonants in a word}
{Uses TStringList capabilities to do this}
var I: integer;
var SL: TStringList;
begin
SL:=TStringList.Create;
try
{Keep sorted for speed}
SL.Sorted:=True;
{insure that no duplicates are added}
SL.Duplicates:=dupIgnore;
for I:=1 to Length(S) do
 if not (S[I] in ['a','e','i','o','u']) then SL.Add(S[I]);
Result:=SL.Count;
finally SL.Free; end;
end;


function SortCompare(List: TStringList; Index1, Index2: Integer): Integer;
{Function used to sort words by consonant count}
begin
{Consonant count stored in the object parts of the string list}
Result:=Integer(List.Objects[Index2])-Integer(List.Objects[Index1]);
end;

{Item used to keep track of the range of }
{ word that have the same consonant count}

type TRangeInfo = record
 Count: integer;
 Start,Stop: integer;
 end;

type TRangeArray = array of TRangeInfo;


procedure FindMostConsonants(Memo: TMemo);
{Find words with the most consonants}
var I,J,Cnt,CCnt: integer;
var SL: TStringList;
var S: string;
var RA: TRangeArray;
begin
SL:=TStringList.Create;
try
{Choose dictionary words > 10 in length}
for I:=0 to Dict.Count-1 do
 if Length(Dict[I])>10 then
	begin
	{Get the number of consonants}
	Cnt:=CountConsonants(Dict[I]);
	{Store the word with the count casts as an object}
	SL.AddObject(Dict[I],TObject(Cnt));
	end;
{Sort the list by consonant count}
SL.CustomSort(SortCompare);

Cnt:=0;
SetLength(RA,0);
{Get the start and stop of words /c same # of consonants}
for I:=0 to SL.Count-1 do
	begin
	{If the count has changed, add new range variable}
	if Integer(SL.Objects[I])<>Cnt then
		begin
		Cnt:=Integer(SL.Objects[I]);
		if Length(RA)>0 then RA[High(RA)].Stop:=I-1;
		SetLength(RA,Length(RA)+1);
		RA[High(RA)].Count:=Cnt;
		RA[High(RA)].Start:=I;
		end;
	end;
RA[High(RA)].Stop:=SL.Count-1;
{Display consonant information}
Memo.Lines.BeginUpdate;
try
for I:=0 to High(RA) do
	begin
	Cnt:=RA[I].Stop-RA[I].Start;
	Memo.Lines.Add(IntToStr(Cnt)+' words with '+IntToStr(RA[I].Count)+' Consonants');
	S:=''; Cnt:=0;
	for J:=RA[I].Start to RA[I].Stop do
		begin
		Inc(Cnt);
		S:=S+Format('%-23s',[SL[J]]);
		if (Cnt mod 4)=0 then S:=S+#$0D#$0A
		end;
	Memo.Lines.Add(S);
	end;
finally Memo.Lines.EndUpdate; end;
finally SL.Free; end;
end;



initialization
{Create/load dictionary}
Dict:=TStringList.Create;
Dict.LoadFromFile('unixdict.txt');
Dict.Sorted:=True;
finalization
Dict.Free;
end.

