{Custom object forms basic generator}

type TCustomGen = class(TObject)
 private
  FNumber: integer;
  FExponent: integer;
  FStart: integer;
 protected
   property Exponent: integer read FExponent write FExponent;
 public
   constructor Create; virtual;
   procedure Reset;
   function Next: integer; virtual;
   procedure Skip(Count: integer);
   property Start: integer read FStart write FStart;
 end;

{Child object specifically for generating Squares}

type TSquareGen = class(TCustomGen)
 public
  constructor Create; override;
  end;


{Child object specifically for generating cubes}

type TCubeGen = class(TCustomGen)
 public
  constructor Create; override;
  end;

{Child object specifically for filtering squares}

type TFilterSquareGen = class(TSquareGen)
 private
  function IsCube(N: integer): boolean;
 public
  function Next: integer; override;
  end;

{ TCustomGen }

constructor TCustomGen.Create;
begin
Start:=0;
{Default to returning X^1}
Exponent:=1;
Reset;
end;


function TCustomGen.Next: integer;
{Find next number in sequence}
var I: integer;
begin
Result:=FNumber;
{Raise to specified power}
for I:=1 to FExponent-1 do Result:=Result * Result;
{Get next base}
Inc(FNumber);
end;


procedure TCustomGen.Reset;
begin
FNumber:=Start;
end;


procedure TCustomGen.Skip(Count: integer);
{Skip specified number of items}
var I: integer;
begin
for I:=1 to Count do Next;
end;

{ TSquareGen }

constructor TSquareGen.Create;
begin
inherited;
Exponent:=2;
end;

{ TCubeGen }

constructor TCubeGen.Create;
begin
inherited;
Exponent:=3;
end;

{ TFilterSquareGen }

function TFilterSquareGen.IsCube(N: integer): boolean;
{Test if number is perfect cube}
var I: integer;
begin
I:=Round(Power(N,1/3));
Result:=I*I*I = N;
end;



function TFilterSquareGen.Next: integer;
begin
{Gets inherited next square, rejects cubes}
repeat Result:=inherited Next
until not IsCube(Result);
end;


{-----------------------------------------------------------}

procedure DoTest(Memo: TMemo; Gen: TCustomGen; SkipCnt: integer; Title: string);
{Carry out TGenerators tests. "Gen" is a TCustomGen which is the parent of}
{all generators. That means "DoTest" can work with any type of generator}
var S: string;
var I,V: integer;
begin
Gen.Reset;
Gen.Skip(SkipCnt);
Memo.Lines.Add(Title);
S:='[';
for I:=1 to 10 do S:=S+Format(' %d',[Gen.Next]);
Memo.Lines.Add(S+']');
end;



procedure TestGenerators(Memo: TMemo);
{Tests all three types of generators}
var SquareGen: TSquareGen;
var CubeGen: TCubeGen;
var Filtered: TFilterSquareGen;
begin
SquareGen:=TSquareGen.Create;
try
CubeGen:=TCubeGen.Create;
try
Filtered:=TFilterSquareGen.Create;
try
DoTest(Memo,SquareGen,0,'Testing Square Generator');
DoTest(Memo,CubeGen,0,'Testing Cube Generator');
DoTest(Memo,Filtered,20,'Testing Squares with cubes removed');

finally Filtered.Free; end;
finally CubeGen.Free; end;
finally SquareGen.Free; end;
end;
