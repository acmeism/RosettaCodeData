{These routines would normally be in a separate library; they are presented here for clarity}


{Permutator based on the Johnson and Trotter algorithm.}
{Which only permutates by swapping a pair of elements at a time}
{object steps through all permutation of array items}
{Zero-Based = True = 0..Permutions-1 False = 1..Permutaions}
{Permutation set on "Create(Size)" or by "Permutations" property}
{Permutation are contained in the array "Indices"}

type TDirection = (drLeftToRight,drRightToLeft);
type TDirArray = array of TDirection;


type TJTPermutator = class(TObject)
 private
  Dir: TDirArray;
  FZeroBased: boolean;
  FBase: integer;
  FPermutations: integer;
  procedure SetZeroBased(const Value: boolean);
  procedure SetPermutations(const Value: integer);
 protected
   FMax: integer;
 public
  NextCount: Integer;
  Indices: TIntegerDynArray;
  constructor Create(Size: integer);
  procedure Reset;
  function Next: boolean;
  property ZeroBased: boolean read FZeroBased write SetZeroBased;
  property Permutations: integer read FPermutations write SetPermutations;
 end;


{==============================================================================}

function Fact(N: integer): integer;
{Get factorial of N}
var I: integer;
begin
Result:=1;
for I:=1 to N do Result:=Result * I;
end;


procedure SwapIntegers(var A1,A2: integer);
{Swap integer arguments}
var T: integer;
begin
T:=A1; A1:=A2; A2:=T;
end;


procedure TJTPermutator.Reset;
var I: integer;
begin
{ Preset items 0..n-1 or 1..n depending on base}
for I:=0 to High(Indices) do Indices[I]:=I + FBase;
{ initially all directions are set to RIGHT TO LEFT }
for I:=0 to High(Indices) do Dir[I]:=drRightToLeft;
NextCount:=0;
end;


procedure TJTPermutator.SetPermutations(const Value: integer);
begin
if FPermutations<>Value then
	begin
	FPermutations := Value;
	SetLength(Indices,Value);
	SetLength(Dir,Value);
	Reset;
	end;
end;



constructor TJTPermutator.Create(Size: integer);
begin
ZeroBased:=True;
Permutations:=Size;
Reset;
end;



procedure TJTPermutator.SetZeroBased(const Value: boolean);
begin
if FZeroBased<>Value then
	begin
	FZeroBased := Value;
	if Value then FBase:=0
	else FBase:=1;
	Reset;
	end;
end;


function TJTPermutator.Next: boolean;
{Step to next permutation}
{Returns true when sequence completed}
var Mobile,Pos,I: integer;
var S: string;

	function FindLargestMoble(Mobile: integer): integer;
	{Find position of largest mobile integer in A}
	var I: integer;
	begin
	for I:=0 to  High(Indices) do
	 if Indices[I] = Mobile then
		begin
		Result:=I + 1;
		exit;
		end;
	Result:=-1;
	end;


	function GetMobile: integer;
	{ find the largest mobile integer.}
	var LastMobile, Mobile: integer;
	var I: integer;
	begin
	LastMobile:= 0; Mobile:= 0;
	for I:=0 to High(Indices) do
		begin
		{ direction 0 represents RIGHT TO LEFT.}
		if (Dir[Indices[I] - 1] = drRightToLeft) and (I<>0) then
			begin
			if (Indices[I] > Indices[I - 1]) and (Indices[I] > LastMobile) then
				begin
				Mobile:=Indices[I];
				LastMobile:=Mobile;
				end;
			end;

	        { direction 1 represents LEFT TO RIGHT.}
	        if (dir[Indices[I] - 1] = drLeftToRight) and (i<>(Length(Indices) - 1)) then
			begin
			if (Indices[I] > Indices[I + 1]) and (Indices[I] > LastMobile) then
				begin
				Mobile:=Indices[I];
				LastMobile:=Mobile;
				end;
			end;
		end;

	if (Mobile = 0) and (LastMobile = 0) then Result:=0
	else Result:=Mobile;
	end;



begin
Inc(NextCount);
Result:=NextCount>=Fact(Length(Indices));
if Result then
	begin
	Reset;
	exit;
	end;
Mobile:=GetMobile;
Pos:=FindLargestMoble(Mobile);

{ Swap elements according to the direction in Dir}
if (Dir[Indices[pos - 1] - 1] = drRightToLeft) then SwapIntegers(Indices[Pos - 1], Indices[Pos - 2])
else if (dir[Indices[pos - 1] - 1] = drLeftToRight) then SwapIntegers(Indices[Pos], Indices[Pos - 1]);

{ changing the directions for elements}
{ greater than largest Mobile integer.}
for I:=0 to High(Indices) do
 if Indices[I] > Mobile then
	begin
	if Dir[Indices[I] - 1] = drLeftToRight then Dir[Indices[I] - 1]:=drRightToLeft
	else if (Dir[Indices[i] - 1] = drRightToLeft) then Dir[Indices[I] - 1]:=drLeftToRight;
        end;
end;


{==============================================================================}




function GetPermutationStr(PM: TJTPermutator): string;
var I: integer;
begin
Result:=Format('%2d - [',[PM.NextCount+1]);
for I:=0 to High(PM.Indices) do Result:=Result+IntToStr(PM.Indices[I]);
Result:=Result+'] Sign: ';
if (PM.NextCount and 1)=0 then Result:=Result+'+1'
else Result:=Result+'-1';
end;



procedure SwapPermutations(Memo: TMemo);
var PM: TJTPermutator;
begin
PM:=TJTPermutator.Create(3);
try
repeat Memo.Lines.Add(GetPermutationStr(PM))
until PM.Next;
Memo.Lines.Add('');

PM.Permutations:=4;
repeat Memo.Lines.Add(GetPermutationStr(PM))
until PM.Next;
finally PM.Free; end;
end;
