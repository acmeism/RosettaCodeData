const TreeData1: array [0..0] of integer = (0);
const TreeData2: array [0..2] of integer = (1, 2, 4);
const TreeData3: array [0..3] of integer = (3, 1, 3, 1);
const TreeData4: array [0..3] of integer = (1, 2, 3, 1);
const TreeData5: array [0..3] of integer = (3, 2, 1, 3);
const TreeData6: array [0..7] of integer = (3, 3, 3, 1, 1, 3, 3, 3);


function GetDataString(Data: array of integer): string;
var I: integer;
begin
Result:='[';
for I:=0 to High(Data) do
	begin
	if I<>0 then Result:=Result+', ';
	Result:=Result+IntToStr(Data[I]);
	end;
Result:=Result+']';
end;


function GetNestingLevel(Data: array of integer): string;
var Level,Level2: integer;
var I,J,HLen: integer;
begin
Level:=0;
Result:='';
for I:=0 to High(Data) do
	begin
	Level2:=Data[I];
	if Level2>Level then for J:=Level to Level2-1 do Result:=Result+'['
	else if Level2<Level then
		begin
		for J:=Level-1 downto Level2 do Result:=Result+']';
		Result:=Result+', ';
		end
	else if Level2=0 then
		begin
		Result:='[]';
		break;
		end
	else Result:=Result+', ';
	Result:=Result+IntToStr(Level2);
	Level:=Level2;
	if (I<High(Data)) and (Level<Data[I+1]) then Result:=Result+', ';
	end;
for J:=Level downto 1 do Result:=Result+']';
end;


procedure ShowNestData(Memo: TMemo; Data: array of integer);
begin
Memo.Lines.Add(GetDataString(Data)+' Nests to: ');
Memo.Lines.Add(GetNestingLevel(Data));
Memo.Lines.Add('');
end;

procedure ShowNestingLevels(Memo: TMemo);
var S: string;
begin
ShowNestData(Memo,TreeData1);
ShowNestData(Memo,TreeData2);
ShowNestData(Memo,TreeData3);
ShowNestData(Memo,TreeData4);
ShowNestData(Memo,TreeData5);
ShowNestData(Memo,TreeData6);
end;
