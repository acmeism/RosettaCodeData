program game2048;
uses Crt;
const
    SIZE_MAP = 4;
    SIZETOPBOT = SIZE_MAP*6+6; (* Calculate the length of the top and bottom to create a box around the game  *)
    NOTHING = 0;
    UP = 93;
    RIGHT = 92;
    LEFT = 91;
    DOWN = 90;
type
    type_vector = array [1..SIZE_MAP] of integer;
    type_game = record
	lin,col:integer;
	map: array [1..SIZE_MAP,1..SIZE_MAP] of integer;
	score:integer;
    end;
    type_coord = record
	lin,col:integer;
    end;

var
    game:type_game;
    end_game,movement:boolean;

procedure Create_Number(var game:type_game);
(* Create the number(2 or 4) in a random position on the map *)
(* The number 4 had a 10% of chance to be created *)
var
    number:integer;
    RanP:type_coord;
begin
    randomize;
    if random(9) = 1 then
	number:=4
    else
	number:=2;
    RanP.lin:=random(game.lin)+1;
    RanP.col:=random(game.col)+1;
    while game.map[RanP.lin,RanP.col] <> NOTHING do
	begin
	    RanP.lin:=random(game.lin)+1;
	    RanP.col:=random(game.col)+1;
	end;
    game.map[RanP.lin,Ranp.Col]:=number;
end;

procedure initializing_game(var game:type_game);
var i,j:integer;
begin
    game.lin:=SIZE_MAP;
    game.col:=SIZE_MAP;
    game.score:=0;
    for i:=1 to game.lin do
	for j:=1 to game.col do
	    game.map[i,j]:=NOTHING;

    Create_Number(game);
    Create_Number(game);
end;

function CountDigit(number:integer):integer;
begin
    if number <> 0 then
	begin
	    CountDigit:=0;
	    while number <> 0 do
		begin
		    CountDigit:=CountDigit+1;
		    number:=number div 10;
		end;
	end
    else
	CountDigit:=1;
end;

procedure print_number(number:integer);
(* Print the number aligned with other numbers in the matrix  *)
var k,hwdigit:integer;
begin
    hwdigit:=CountDigit(number);
    write(' ');
    write(number);
    (* The 4 is used to aling the numbers because the greatest number *)
    (* possible is 2048, which have 4 digits *)
    for k:=1 to 4-hwdigit do
	write(' ');
    write(' ');
end;

procedure print_line(lengthL:integer; ch:string);
var i:integer;
begin
    write('+');
    for i:=1 to (lengthL-2) do
	begin
	    if i mod 7 = 0 then
		write('+')
	    else
		write(ch);
    end;
    writeln;
end;

procedure print_map(var game:type_game);
var i,j:integer;
begin
    print_line(SIZETOPBOT,'-');
    for i:=1 to game.lin do
	begin
	    write('|');
	    for j:=1 to game.col do
		if game.map[i,j] >= 0 then
		    begin
			print_number(game.map[i,j]);
			write('|');
		    end;
	    writeln;
	    print_line(SIZETOPBOT,'-');
	end;
end;

function CanMove(var v_lin:type_vector; i:integer):integer;
(* Returns 1 if the next position is free *)
(* Returns 2 if the next position has an equal number *)
(* Returns 0 if the next position is not free *)
begin
    if v_lin[i-1] = NOTHING then
        CanMove:=1
    else if v_lin[i] = v_lin[i-1] then
        CanMove:=2
    else
        CanMove:=0;
end;

function MoveAndSum(var game:type_game; var v_lin:type_vector; size:integer):boolean;
(* Move and Sum the elements of the vector *)
(* The direction of the move is to the left *)
(* Returns TRUE if a number was moved *)
(* Returns FALSE if a number was not moved *)
var
    i,e,ResultM:integer;
    v:type_vector;
begin
    MoveAndSum:=FALSE;
    (* Initializing the vector *)
    (* This Vector is to know what number sum and what not sum *)
    for i:=1 to size do
        v[i]:=0;

    for i:=2 to size do
        begin
	    if v_lin[i] <> 0 then
		begin
		    (* Move the number in v_lin[i] to the left as much as possible *)
		    e:=i;
		    ResultM:=CanMove(v_lin,e);
		    while (ResultM <> 0)and(e>1) do
			begin
			    case ResultM of
				1:begin
				    v_lin[e-1]:=v_lin[e];
				    v_lin[e]:=NOTHING;
				end;
				2:begin
				    if v[e] = 0 then
					begin
					    v_lin[e-1]:=v_lin[e-1]*2;
					    game.score:=game.score+v_lin[e-1];
					    v_lin[e]:=NOTHING;
					    (* This number will not be sum again *)
					    v[e-1]:=1;
					end;
				end;
			    end;
			    e:=e-1;
			    ResultM:=CanMove(v_lin,e);
			end;
		    if e <> i then
			MoveAndSum:=TRUE;
		    v[e-1]:=1;
		end;
        end;
end;


function move_left(var game:type_game):boolean;
var
    i,j:integer;
    v:type_vector;
begin
    move_left:=FALSE;
    for i:=1 to game.lin do
	begin
	    for j:=1 to game.col do
		v[j]:=game.map[i,j];

	    if MoveAndSum(game,v,game.lin) then
		move_left:=TRUE;

	    for j:=1 to game.col do
		game.map[i,j]:=v[j];
	end;
end;


function move_right(var game:type_game):boolean;
var
    i,j,k:integer;
    v:type_vector;
begin
    move_right:=FALSE;
    for i:=1 to game.lin do
	begin
	    (* The side which will be move had to be at the beginning of the vector *)
	    (* For example, I want to move this line to the right: 0 2 0 3 6 *)
	    (* The procedure "MoveAndSum" has to receive this vector: 6 3 0 2 0 *)
	    k:=1;
	    for j:=game.col downto 1 do
		begin
		    v[k]:=game.map[i,j];
		    k:=k+1;
		end;
	    if MoveAndSum(game,v,game.lin) then
		move_right:=TRUE;
	    (* Copy to the right place in the matrix *)
	    k:=1;
	    for j:=game.col downto 1 do
		begin
		    game.map[i,k]:=v[j];
		    k:=k+1;
		end;
	end;
end;


function move_down(var game:type_game):boolean;
var
    i,j,k:integer;
    v:type_vector;
begin
    move_down:=FALSE;
    for j:=1 to game.col do
	begin
	    k:=1;
	    for i:=game.lin downto 1 do
		begin
		    v[k]:=game.map[i,j];
		    k:=k+1;
		end;
	    if MoveAndSum(game,v,game.lin) then
		move_down:=TRUE;
	    k:=1;
	    for i:=game.lin downto 1 do
		begin
		    game.map[k,j]:=v[i];
		    k:=k+1;
		end;
	end;
end;

function move_up(var game:type_game):boolean;
var
    i,j:integer;
    v:type_vector;
begin
    move_up:=FALSE;
    for j:=1 to game.col do
	begin
	    for i:=1 to game.lin do
		v[i]:=game.map[i,j];
	    if MoveAndSum(game,v,game.lin) then
		move_up:=TRUE;
	    for i:=1 to game.lin do
		game.map[i,j]:=v[i];
	end;
end;

function CheckWinLose(var game:type_game):integer;
(* Returns 2 if the player win the game *)
(* Returns 1 if the player lose the game *)
(* Returns 0 if has a valid move*)
var i,j:integer;
begin
    with game do
	begin
	    CheckWinLose:=1;
	    i:=1;
	    while (i<=game.lin)and(CheckWinLose<>2) do
		begin
		    j:=1;
		    while (j<=game.col)and(CheckWinLose<>2) do
			begin
			    if map[i,j] = 2048 then
				CheckWinLose:=2
			    else
			       if map[i,j] = NOTHING then
				CheckWinLose:=0
			    else
				if (map[i,j] = map[i,j+1])and(j<>col) then
				    CheckWinLose:=0
			    else
				if (map[i,j] = map[i,j-1])and(j<>1) then
				    CheckWinLose:=0
			    else
				if (map[i,j] = map[i+1,j])and(i<>lin) then
				    CheckWinLose:=0
			    else
				if (map[i,j] = map[i-1,j])and(i<>1) then
				    CheckWinLose:=0;
			    j:=j+1;
			end;
		    i:=i+1;
		end;
    end;
end;

begin
    movement:=false;
    end_game:=false;
    initializing_game(game);
    repeat
	ClrScr;
	if movement then
	    Create_Number(game);
	movement:=false;

	writeln('SCORE: ',game.score);
	print_map(game);
	writeln(' Use the arrow keys to move ');
	writeln(' Press ESC to quit the game ');

	case CheckWinLose(game) of
	    1:begin
		print_line(SIZETOPBOT,'-');
		writeln('|         Game Over!        |');
		print_line(SIZETOPBOT,'-');
		end_game:=TRUE;
	    end;
	    2:begin
		print_line(SIZETOPBOT,'-');
		writeln('|          You Win!         |');
		print_line(SIZETOPBOT,'-');
		end_game:=TRUE;
	    end;
	end;

	repeat
	until KeyPressed;
	case ReadKey of
	     #0:begin
		case ReadKey of
		    #72:movement:=move_up(game);
		    #77:movement:=move_right(game);
		    #75:movement:=move_left(game);
		    #80:movement:=move_down(game);
		end;
	    end;
	    #27:end_game:=true;
	end;
    until end_game;
end.
