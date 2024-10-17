var Towers1: array [0..4] of integer = (1, 5, 3, 7, 2);
var Towers2: array [0..9] of integer = (5, 3, 7, 2, 6, 4, 5, 9, 1, 2);
var Towers3: array [0..15] of integer = (2, 6, 3, 5, 2, 8, 1, 4, 2, 2, 5, 3, 5, 7, 4, 1);
var Towers4: array [0..3] of integer = (5, 5, 5, 5);
var Towers5: array [0..3] of integer = (5, 6, 7, 8);
var Towers6: array [0..3] of integer = (8, 7, 7, 6);
var Towers7: array [0..4] of integer = (6, 7, 10, 7, 6);


type TMatrix = array of array of boolean;

function ArrayToMatrix(Towers: array of integer): TMatrix;
{Convert Tower Array to Matrix for analysis}
var Max,I,X,Y: integer;
begin
Max:=0;
for I:=0 to High(Towers) do if Towers[I]>=Max then Max:=Towers[I];
SetLength(Result,Length(Towers),Max);
for Y:=0 to High(Result[0]) do
 for X:=0 to High(Result) do Result[X,Y]:=Towers[X]>(Max-Y);
end;


procedure DisplayMatrix(Memo: TMemo; Matrix: TMatrix);
{Display a matrix}
var X,Y: integer;
var S: string;
begin
for Y:=0 to High(Matrix[0]) do
	begin
	S:='[';
	for X:=0 to High(Matrix) do
		begin
		if Matrix[X,Y] then S:=S+'#'
		else S:=S+' ';
		end;
	S:=S+']';
	Memo.Lines.Add(S);
	end;
end;


function GetWaterStorage(Matrix: TMatrix): integer;
{Analyze matrix to get water storage amount}
var X,Y,Cnt: integer;
var Inside: boolean;
begin
Result:=0;
{Scan each row of matrix to see if it is storing water}
for Y:=0 to High(Matrix[0]) do
	begin
	Inside:=False;
	Cnt:=0;
 	for X:=0 to High(Matrix) do
		begin
		{Test if this is a tower}
		if Matrix[X,Y] then
			begin
			{if so, we may be inside trough}
			Inside:=True;
			{If Cnt>0 there was a previous tower}
			{And we've impounded water }
			Result:=Result+Cnt;
			{Start new count with new tower}
			Cnt:=0;
			end
		else if Inside then Inc(Cnt);	{Count potential impounded water}
		end;
	end;
end;


procedure ShowWaterLevels(Memo: TMemo; Towers: array of integer);
{Analyze the water storage of towers and display result}
var Water: integer;
var Matrix: TMatrix;
begin
Matrix:=ArrayToMatrix(Towers);
DisplayMatrix(Memo,Matrix);
Water:=GetWaterStorage(Matrix);
Memo.Lines.Add('Storage: '+IntToStr(Water)+CRLF);
end;


procedure WaterLevel(Memo: TMemo);
begin
ShowWaterLevels(Memo,Towers1);
ShowWaterLevels(Memo,Towers2);
ShowWaterLevels(Memo,Towers3);
ShowWaterLevels(Memo,Towers4);
ShowWaterLevels(Memo,Towers5);
ShowWaterLevels(Memo,Towers6);
ShowWaterLevels(Memo,Towers7);
end;
