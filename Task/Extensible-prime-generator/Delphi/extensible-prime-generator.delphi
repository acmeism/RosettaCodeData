{{-------- Declaration for BitBoolean Array ------------------}

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


{------------------------------------------------------------}
{ Implementation for Bitboolean array -----------------------}
{------------------------------------------------------------}

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




{========== TPrimeSieve =======================================================}


{Sieve object the generates and holds prime values}

{Enable this flag if you need primes past 2 billion.
The flag signals the code to use bit-booleans arrays
which can contain up to 8 x 4 gigabytes = 32 gig booleans.}

// {$define BITBOOL}

type TPrimeSieve = class(TObject)
 private
  {$ifdef BITBOOL}
  PrimeArray: TBitBoolArray;
  {$else}
  PrimeArray: array of boolean;
  {$endif}
  FArraySize: int64;
    FPrimeCount: int64;
  function GetPrime(Index: int64): boolean;
  procedure Clear;
  function GetCount: int64;
    procedure BuildPrimeTable;
 protected
   procedure DoSieve;
   property ArraySize: int64 read FArraySize;
 public
   Primes: TIntegerDynArray;
   BitBoolean: boolean;
   constructor Create;
   destructor Destroy; override;
   procedure Intialize(Size: int64);
   property Flags[Index: int64]: boolean read GetPrime; default;
   function NextPrime(Start: int64): int64;
   function PreviousPrime(Start: int64): int64;
   property Count: int64 read GetCount;
   property PrimeCount: int64 read FPrimeCount;
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



procedure TPrimeSieve.BuildPrimeTable;
{This builds a table of primes which is}
{easier to use than a table of flags}
var I,Inx: integer;
begin
SetLength(Primes,Self.PrimeCount);
Inx:=0;
for I:=0 to Self.Count-1 do
 if Flags[I] then
	begin
	Primes[Inx]:=I;
	Inc(Inx);
	end;
end;



procedure TPrimeSieve.DoSieve;
{Load flags with true/false to flag that number is prime}
{Note: does not store even values, because except for 2, all primes are even}
{Starts storing flags at Index=3, so reading/writing routines compensate}
{Uses for-loops for boolean arrays and while-loops for Bit-Booleans arrays}
{$ifdef BITBOOL}
var Offset, I, K: int64;
{$else}
var Offset, I, K: cardinal;
{$endif}
begin
Clear;
{Compensate from primes 1,2 & 3, which aren't stored}
FPrimeCount:=ArraySize+3;
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
			if PrimeArray[K] then Dec(FPrimeCount);
			PrimeArray[K]:= False;
			K:= K + Offset;
			end;
		end;
	{$ifdef BITBOOL} Inc(I); {$endif}
	end;
BuildPrimeTable;
end;



function TPrimeSieve.GetPrime(Index: int64): boolean;
{Get a prime flag from array - compensates}
{ for 0,1,2 and even numbers not being stored}
begin
if Index = 1 then Result:=False
else if Index = 2 then Result:=True
else if (Index and 1)=0 then Result:=false
else Result:=PrimeArray[(Index div 2)-1];
end;


function TPrimeSieve.NextPrime(Start: int64): int64;
{Get next prime after Start}
begin
Result:=Start+1;
while Result<=((ArraySize-1) * 2) do
	begin
	if Self.Flags[Result] then break;
	Inc(Result);
	end;
end;



function TPrimeSieve.PreviousPrime(Start: int64): int64;
{Get Previous prime Before Start}
begin
Result:=Start-1;
while Result>0 do
	begin
	if Self.Flags[Result] then break;
	Dec(Result);
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



function TPrimeSieve.GetCount: int64;
begin
Result:=FArraySize * 2;
end;


{===========================================================}

procedure ExtensiblePrimeGenerator(Memo: TMemo);
var I,Cnt: integer;
var Sieve: TPrimeSieve;
var S: string;
begin
Sieve:=TPrimeSieve.Create;
try
{Build a table with 1-million primes}
Sieve.Intialize(1000000);

Memo.Lines.Add('Showing the first twenty primes');
S:='';
for I:=0 to 20-1 do
S:=S+' '+IntToStr(Sieve.Primes[I]);
Memo.Lines.Add(S);
Memo.Lines.Add('');

Memo.Lines.Add('Showing the primes between 100 and 150.');
S:='';
for I:=100 to 150 do
 if Sieve.Flags[I] then S:=S+' '+IntToStr(I);
Memo.Lines.Add(S);
Memo.Lines.Add('');

Memo.Lines.Add('Showing the number of primes between 7,700 and 8,000.');
Cnt:=0;
for I:=7700 to 8000 do
 if Sieve.Flags[I] then Inc(Cnt);
Memo.Lines.Add('Count = '+IntToStr(Cnt));
Memo.Lines.Add('');

Memo.Lines.Add('Showing the 10,000th prime.');
Memo.Lines.Add('10,000th Prime = '+IntToStr(Sieve.Primes[10000-1]));
finally Sieve.Free; end;
end;
