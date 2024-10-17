{Bit boolean - because it stores 8 bools per bytye, it will}
{handle up to 16 gigabyte in a 32 bit programming environment}

type TBitBoolArray = class(TObject)
 private
  FSize: int64;
  ByteArray: array of Byte;
  function GetValue(Index: int64): boolean;
  procedure WriteValue(Index: int64; const Value: boolean);
  function GetSize: int64;
  procedure SetSize(const Value: int64);
 protected
 public
  property Value[Index: int64]: boolean read GetValue write WriteValue; default;
  constructor Create;
  property Count: int64 read GetSize write SetSize;
  procedure Clear(Value: boolean);
 end;



{ TBitBoolArray }

const BitArray: array [0..7] of byte = ($01, $02, $04, $08, $10, $20, $40, $80);

function TBitBoolArray.GetValue(Index: int64): boolean;
begin
{Note: (Index and 7) is faster than (Index mod 8)}
Result:=(ByteArray[Index shr 3] and BitArray[Index and 7])<>0;
end;


procedure TBitBoolArray.WriteValue(Index: int64; const Value: boolean);
var Inx: int64;
begin
Inx:=Index shr 3;
{Note: (Index and 7) is faster than (Index mod 8)}
if Value then ByteArray[Inx]:=ByteArray[Inx] or BitArray[Index and 7]
else ByteArray[Inx]:=ByteArray[Inx] and not BitArray[Index and 7]
end;


constructor TBitBoolArray.Create;
begin
SetLength(ByteArray,0);
end;


function TBitBoolArray.GetSize: int64;
begin
Result:=FSize;
end;


procedure TBitBoolArray.SetSize(const Value: int64);
var Len: int64;
begin
FSize:=Value;
{Storing 8 items per byte}
Len:=Value div 8;
{We need one more to fill partial bits}
if (Value mod 8)<>0 then Inc(Len);
SetLength(ByteArray,Len);
end;


procedure TBitBoolArray.Clear(Value: boolean);
var Fill: byte;
begin
if Value then Fill:=$FF else Fill:=0;
FillChar(ByteArray[0],Length(ByteArray),Fill);
end;


+++++++++++++++++++++++++++++++++++++++++++++++++++++++++


{Sieve object the generates and holds prime values}

{Enable this flag if you need primes past 2 billion.
The flag signals the code to use bit-booleans arrays
which can contain up to 8 x 4 gigabytes = 32 gig booleans.}

{$define BITBOOL}

type TPrimeSieve = class(TObject)
 private
  {$ifdef BITBOOL}
  PrimeArray: TBitBoolArray;
  {$else}
  PrimeArray: array of boolean;
  {$endif}
  FArraySize: int64;
  function GetPrime(Index: int64): boolean;
  procedure Clear;
 protected
   procedure DoSieve;
   property ArraySize: int64 read FArraySize;
 public
   BitBoolean: boolean;
   constructor Create;
   destructor Destroy; override;
   procedure Intialize(Size: int64);
   property Prime[Index: int64]: boolean read GetPrime; default;
   function NextPrime(Start: int64): int64;
 end;


procedure TPrimeSieve.Clear;
begin
{$ifdef BITBOOL}
PrimeArray.Clear(True);
{$else}
FillChar(PrimeArray[0],Length(PrimeArray),True);
{$endif}
end;



constructor TPrimeSieve.Create;
begin
{$ifdef BITBOOL}
PrimeArray:=TBitBoolArray.Create;
BitBoolean:=True;
{$else}
BitBoolean:=False;
{$endif}
end;


destructor TPrimeSieve.Destroy;
begin
{$ifdef BITBOOL}
PrimeArray.Free;
{$endif}
inherited;
end;


procedure TPrimeSieve.DoSieve;
{Load flags with true/false to flag that number is prime}
{Note: does not store even values, because except for 2, all primes are even}
{Starts storing flags at Index=3, so reading/writing routines compensate}
{Uses for-loops for boolean arrays and while-loops for bitbooleans arrays}
{$ifdef BITBOOL}
var Offset, I, K: int64;
{$else}
var Offset, I, K: cardinal;
{$endif}
begin
Clear;
{$ifdef BITBOOL}
I:=0;
while I<ArraySize do
{$else}
for I:=0 to ArraySize-1 do
{$endif}
	begin
	if PrimeArray[I] then
		begin
		Offset:= I + I + 3;
		K:= I + Offset;
		while K <=(ArraySize-1) do
			begin
			PrimeArray[K]:= False;
			K:= K + Offset;
			end;
		end;
	{$ifdef BITBOOL} Inc(I); {$endif}
	end;
end;



function TPrimeSieve.GetPrime(Index: int64): boolean;
{Get a prime flag from array - compensates}
{ for 0,1,2 and even numbers not being stored}
begin
if Index in [0,1,2] then Result:=True
else if (Index and 1)=0 then Result:=false
else Result:=PrimeArray[(Index div 2)-1];
end;


function TPrimeSieve.NextPrime(Start: int64): int64;
{Get next prime after Start}
begin
Result:=Start+1;
while Result<=((ArraySize-1) * 2) do
	begin
	if Self.Prime[Result] then break;
	Inc(Result);
	end;
end;


procedure TPrimeSieve.Intialize(Size: int64);
{Set array size and do Sieve to load flag array with}
begin
FArraySize:=Size div 2;
{$ifdef BITBOOL}
PrimeArray.Count:=FArraySize;
{$else}
SetLength(PrimeArray,FArraySize);
{$endif}
DoSieve;
end;

{-------------------------------------------------------------------------------}



type TTripleInfo = record
 Prime1,Prime2,Prime3: int64;
 Count: int64;
 end;

{Iterator for Ormiston Triple}

type TOrm3Iterator = class(TObject)
  FInfo: TTripleInfo;
  PS: TPrimeSieve;
 private
  function IsOrmistonTriple(P1, P2, P3: int64): boolean;
  function EncodeNumber(N: int64): int64;
 protected
 public
  procedure Reset;
  procedure SetSize(Size: int64);
  function GetNext(Limit: int64; var Info: TTripleInfo): boolean;
  constructor Create;
  destructor Destroy; override;
 end;



procedure TOrm3Iterator.Reset;
{Restart iterator}
begin
FInfo.Count:=0;
FInfo.Prime1:=1; FInfo.Prime2:=3; FInfo.Prime3:=5;
end;



procedure TOrm3Iterator.SetSize(Size: int64);
begin
PS.Intialize(Size);
Reset;
end;


constructor TOrm3Iterator.Create;
begin
PS:=TPrimeSieve.Create;
{Start with trivial prime set}
SetSize(100);
end;


destructor TOrm3Iterator.Destroy;
begin
PS.Free;
inherited;
end;



function TOrm3Iterator.EncodeNumber(N: int64): int64;
{Encode N by counting digits 0..9 into nibbles}
{Get the product of the integers in a number}
var T: integer;
const NibMap: array [0..9] of int64 = (
	{0} $1, {1} $10, {2} $100, {3} $1000, {4} $10000, {5} $100000,
	{6} $1000000, {7} $10000000, {8} $100000000, {9} $1000000000);
begin
Result:=0;
repeat
	begin
	T:=N mod 10;
	N:=N div 10;
	Result:=Result + NibMap[T];
	end
until N<1;
end;


function TOrm3Iterator.IsOrmistonTriple(P1,P2,P3: int64): boolean;
var Pd1,Pd2,Pd3: int64;
begin
Result:=False;
{Optimization - difference in primes should be multiple of 18}
if (((P2 - P1) mod 18)<>0) or (((p3 - p2) mod 18)<>0) then exit;
Pd1:=EncodeNumber(P1);
Pd2:=EncodeNumber(P2);
if Pd1<>Pd2 then exit;
Pd3:=EncodeNumber(P3);
Result:=Pd2=Pd3;
end;


function TOrm3Iterator.GetNext(Limit: int64; var Info: TTripleInfo): boolean;
{Iterate to next Ormiston Pair - automatically stop at prime>Limit}
{Returns false if it hits limit - true if it found Next Ormiston Pair}
begin
Result:=False;
while true do
	begin
	{Get next set of primes}
	FInfo.Prime1:=FInfo.Prime2;
	FInfo.Prime2:=FInfo.Prime3;
	FInfo.Prime3:=PS.NextPrime(FInfo.Prime3);
	{Abort if 3rd prime is ove limit}
	if FInfo.Prime3>=Limit then break;
	{Test if it is an Ormiston triple}
	if IsOrmistonTriple(FInfo.Prime1,FInfo.Prime2,FInfo.Prime3) then
		begin
		{Return info on triple}
		Inc(FInfo.Count);
		Info:=FInfo;
		Result:=True;
		break;
		end;
	end;
end;


procedure ShowOrmistonTriple(Memo: TMemo);
var I: integer;
var S: string;
var OI: TOrm3Iterator;
var Info: TTripleInfo;
const Limit = 10000000000;
const DisMod = Limit div 10000000;
const Bill = Limit div 1000000000;
var NS: string;

	procedure DisplayTitle;
	begin
	NS:=IntToStr(Bill)+'-Billion';
	Memo.Lines.Add('====== Find Ormiston Triples ======');
	Memo.Lines.Add('First 25 plus number to '+NS);
	S:='Bit-Boolean Array: ';
	if OI.PS.BitBoolean then S:=S+'Yes' else S:=S+'No';
	Memo.Lines.Add(S);
	end;

begin
{Create iterator}
OI:=TOrm3Iterator.Create;
try
DisplayTitle;
Memo.Lines.Add('Sieving Primes');
OI.SetSize(Limit);
Memo.Lines.Add('Finding first 25 Triples');
{Iterate throug 1st 25 tuples}
for I:=1 to 25 do
	begin
	OI.GetNext(High(Int64),Info);
	Memo.Lines.Add(Format('%3d - (%6D %6D %6D) ',[I,Info.Prime1,Info.Prime2,Info.Prime3]));
	end;
Memo.Lines.Add('Count='+IntToStr(Info.Count));
Memo.Lines.Add('Counting triples to '+NS);
{Iterate to limit number of triples}
while OI.GetNext(Limit,Info) do
if (Info.Count mod DisMod)=0 then Memo.Lines.Add('Count='+IntToStr(Info.Count));
Memo.Lines.Add(NS+'='+IntToStr(Info.Count));
finally OI.Free; end;
end;
