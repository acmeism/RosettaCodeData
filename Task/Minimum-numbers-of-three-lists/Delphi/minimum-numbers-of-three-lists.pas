type TNumList =  array [0..2, 0..4] of integer;

const NumLists: TNumList = (
	(5,45,23,21,67),
	(43,22,78,46,38),
	(9,98,12,98,53));


type TIntArray = array of integer;

procedure GetMinimumCols(NumList: TNumList; var ColMins: TIntArray);
{Get the minimum value is each colum and store in array}
var X,Y: integer;
var Low: integer;
begin
for X:=0 to High(NumLists[0]) do
	begin
        Low:=High(Integer);
        for Y:=0 to High(NumList) do
             if NumLists[Y,X]<Low then Low:=NumList[Y,X];
	SetLength(ColMins,Length(Colmins)+1);
	ColMins[High(ColMins)]:=Low;
	end;
end;



procedure ShowColumnMins(Memo: TMemo);
{Show min value for columns in NumLists}
var ColMins: TIntArray;
var I: integer;
var S: string;
begin
GetMinimumCols(NumLists,ColMins);
S:='[';
for I:=0 to High(ColMins) do
	begin
	if I<>0 then S:=S+' ';
	S:=S+IntToStr(ColMins[I]);
	end;
S:=S+']';
Memo.Lines.Add(S);
end;


