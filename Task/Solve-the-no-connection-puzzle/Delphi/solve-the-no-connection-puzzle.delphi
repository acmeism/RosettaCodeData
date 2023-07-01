{ This item would normally be in a separate library. It is presented here for clarity}

{Permutator object steps through all permutation of array items}
{Zero-Based = True = 0..Permutions-1 False = 1..Permutaions}
{Permutation set on "Create(Size)" or by "Permutations" property}
{Permutation are contained in the array "Indices"}

type TPermutator = class(TObject)
 private
  FZeroBased: boolean;
  FBase: integer;
    FPermutations: integer;
  procedure SetZeroBased(const Value: boolean);
    procedure SetPermutations(const Value: integer);
 protected
   FMax: integer;
 public
  Indices: TIntegerDynArray;
  constructor Create(Size: integer);
  procedure Reset;
  function Next: boolean;
  property ZeroBased: boolean read FZeroBased write SetZeroBased;
  property Permutations: integer read FPermutations write SetPermutations;
 end;



procedure TPermutator.Reset;
var I: integer;
begin
FMax:=High(Indices);
for I:= 0 to High(Indices) do Indices[I]:= I+FBase;
end;



procedure TPermutator.SetPermutations(const Value: integer);
begin
if FPermutations<>Value then
	begin
	FPermutations := Value;
	SetLength(Indices,Value);
	Reset;
	end;
end;



constructor TPermutator.Create(Size: integer);
begin
ZeroBased:=True;
Permutations:=Size;
Reset;
end;


function TPermutator.Next: boolean;
{Returns true when sequence completed}
var I,T: integer;
begin
while true do
	begin
	T:= Indices[0];
	for I:=0 to FMax-1 do Indices[I]:= Indices[I+1];
	Indices[FMax]:= T;
	if T<>(FMax+FBase) then
		begin
		FMax:=High(Indices);
		break;
		end
	else FMax:= FMax-1;
	if FMax<0 then break;
	end;
Result:=FMax<1;
if Result then Reset;
end;



procedure TPermutator.SetZeroBased(const Value: boolean);
begin
if FZeroBased<>Value then
	begin
	FZeroBased := Value;
	if Value then FBase:=0
	else FBase:=1;
	Reset;
	end;
end;

{------------------------------------------------------------------------------}

{Network structures}
{Puzzle node}

type TPuzNode = record
 Name: string;
 Value: integer;
 end;
type PPuzNode = ^TPuzNode;

{Edges connecting nodes}

type TPuzEdge = record
 N1,N2: ^TPuzNode;
 end;

{All edges in puzzle}

var Edges: array [0..14] of TPuzEdge;

{All nodes in puzzle}

var A: TPuzNode = (Name: 'A'; Value: 1);
var B: TPuzNode = (Name: 'B'; Value: 2);
var C: TPuzNode = (Name: 'C'; Value: 3);
var D: TPuzNode = (Name: 'D'; Value: 4);
var E: TPuzNode = (Name: 'E'; Value: 5);
var F: TPuzNode = (Name: 'F'; Value: 6);
var G: TPuzNode = (Name: 'G'; Value: 7);
var H: TPuzNode = (Name: 'H'; Value: 8);

{Array of pointers to puzzle nodes }

var PuzNodes: array [0..7] of Pointer;

procedure BuildNetwork;
{Build puzzle net work}
begin
{Put pointers to nodes in array}
PuzNodes[0]:=@A;
PuzNodes[1]:=@B;
PuzNodes[2]:=@C;
PuzNodes[3]:=@D;
PuzNodes[4]:=@E;
PuzNodes[5]:=@F;
PuzNodes[6]:=@G;
PuzNodes[7]:=@H;
{Set up all edges}
Edges[0].N1:=@A; Edges[0].N2:=@C;
Edges[1].N1:=@A; Edges[1].N2:=@D;
Edges[2].N1:=@A; Edges[2].N2:=@E;
Edges[3].N1:=@B; Edges[3].N2:=@D;
Edges[4].N1:=@B; Edges[4].N2:=@E;
Edges[5].N1:=@B; Edges[5].N2:=@F;
Edges[6].N1:=@G; Edges[6].N2:=@C;
Edges[7].N1:=@G; Edges[7].N2:=@D;
Edges[8].N1:=@G; Edges[8].N2:=@E;
Edges[9].N1:=@H; Edges[9].N2:=@D;
Edges[10].N1:=@H; Edges[10].N2:=@E;
Edges[11].N1:=@H; Edges[11].N2:=@F;
Edges[12].N1:=@C; Edges[12].N2:=@D;
Edges[13].N1:=@D; Edges[13].N2:=@E;
Edges[14].N1:=@E; Edges[14].N2:=@F;
end;



function ValidPattern: boolean;
{Test if pattern of node values is valid}
{i.e., edges values are greater than 1}
var I: integer;
begin
Result:=False;
for I:=0 to High(Edges) do
 if abs(Edges[I].N2.Value-Edges[I].N1.Value)<2 then exit;
Result:=True;
end;


function Permutate: boolean;
{Use permutator object to iterate through all combinations}
var PM: TPermutator;
var I: integer;
begin
{Create with 8 items}
PM:=TPermutator.Create(8);
try
{Set to make it 1..8}
PM.ZeroBased:=False;
Result:=True;
{Iterate through all permutation}
while not PM.Next do
	begin
	{Copy permutation into network}
	for I:=0 to High(PM.Indices) do
		PPuzNode(PuzNodes[I])^.Value:=PM.Indices[I];
	{If permutation is valid exit}
	if ValidPattern then exit;
	end;
{No valid permutation found}
Result:=False;
finally PM.Free; end;
end;

{String to display game board}

var GameBoard: string =
	'       A   B'+CRLF+
	'      /|\ /|\'+CRLF+
	'     / | X | \'+CRLF+
	'    /  |/ \|  \'+CRLF+
	'   C - D - E - F'+CRLF+
	'    \  |\ /|  /'+CRLF+
	'     \ | X | /'+CRLF+
	'      \|/ \|/'+CRLF+
	'       G   H'+CRLF;


procedure ShowPuzzle(Memo: TMemo);
{Display game board with correct answer inserted}
var I,Inx: integer;
var S: string;
var PN: TPuzNode;
begin
S:=GameBoard;
{Search for Letters A..H}
for I:=1 to Length(S) do
 if S[I] in ['A'..'H'] then
	begin
	{Convert A..H to index}
	Inx:=byte(S[I]) - $41;
	{Get node A..H}
	PN:=PPuzNode(PuzNodes[Inx])^;
	{Store value in corresponding node}
	S[I]:=char(PN.Value+$30);
	end;
{Display board}
Memo.Lines.Add(S);
end;


procedure ConnectionPuzzle(Memo: TMemo);
{Solve connection puzzle}
var S: string;
var I: integer;
var PN: TPuzNode;
begin
BuildNetwork;
Permutate;
{Display result}
S:='';
for I:=0 to High(PuzNodes) do
	begin
	PN:=PPuzNode(PuzNodes[I])^;
	S:=S+PN.Name+'='+IntToStr(PN.Value)+' ';
	end;
Memo.Lines.Add(S);
{Show puzzle with values inserted}
ShowPuzzle(Memo);
end;
