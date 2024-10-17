type TGame = string[20];
type TPattern = string[3];

function GetSubPattern(Game: TGame; Inx: integer): TPattern;
{Get the pattern of three cells adjacent to Inx}
var I: integer;
begin
Result:='';
{Cells off the ends of the array are consider empty}
for I:=Inx-1 to Inx+1 do
 if (I<1) or (I>Length(Game)) then Result:=Result+' '
 else Result:=Result+Game[I];
end;

function GetNewValue(P: TPattern): char;
{Calculate the new value for a cell based}
{the pattern of neighboring cells}
begin
if      P='   ' then Result:=' '	{ No change}
else if P='  #' then Result:=' '	{ No change}
else if P=' # ' then Result:=' '	{ Dies without enough neighbours}
else if P=' ##' then Result:='#'	{ Needs one neighbour to survive}
else if P='#  ' then Result:=' '	{ No change}
else if P='# #' then Result:='#'	{ Two neighbours giving birth}
else if P='## ' then Result:='#'	{ Needs one neighbour to survive}
else if P='###' then Result:=' ';	{ Starved to death.}
end;


procedure CellularlAutoGame(Memo: TMemo);
{Iterate through steps of evolution of cellular automaton}
var GameArray,NextArray: TGame;
var P: string [3];
var I,G: integer;
begin
{Start arrangement}
GameArray:=' ### ## # # # #  #  ';
for G:=1 to 10 do
	begin
	{Display current game situation}
	Memo.Lines.Add(GameArray);
	{Evolve each cell in the array}
	for I:=1 to Length(GameArray) do
		begin
		P:=GetSubPattern(GameArray,I);
	   	NextArray[I]:=GetNewValue(P);
	   	end;
	GameArray:=NextArray;
	end;
end;
