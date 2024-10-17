program PCG32_test;

{$APPTYPE CONSOLE}
uses
  System.SysUtils,
  Velthuis.BigIntegers,
  System.Generics.Collections;

type
  TPCG32 = class
  public
    FState: BigInteger;
    FInc: BigInteger;
    mask64: BigInteger;
    mask32: BigInteger;
    k: BigInteger;
    constructor Create(seedState, seedSequence: BigInteger); overload;
    constructor Create(); overload;
    destructor Destroy; override;
    procedure Seed(seed_state, seed_sequence: BigInteger);
    function NextInt(): BigInteger;
    function NextIntRange(size: Integer): TArray<BigInteger>;
    function NextFloat(): Extended;
  end;

{ TPCG32 }

constructor TPCG32.Create(seedState, seedSequence: BigInteger);
begin
  Create();
  Seed(seedState, seedSequence);
end;

constructor TPCG32.Create;
begin
  k := '6364136223846793005';
  mask64 := (BigInteger(1) shl 64) - 1;
  mask32 := (BigInteger(1) shl 32) - 1;
  FState := 0;
  FInc := 0;
end;

destructor TPCG32.Destroy;
begin

  inherited;
end;

function TPCG32.NextFloat: Extended;
begin
  Result := (NextInt.AsExtended / (BigInteger(1) shl 32).AsExtended);
end;

function TPCG32.NextInt(): BigInteger;
var
  old, xorshifted, rot, answer: BigInteger;
begin
  old := FState;
  FState := ((old * k) + FInc) and mask64;
  xorshifted := (((old shr 18) xor old) shr 27) and mask32;
  rot := (old shr 59) and mask32;
  answer := (xorshifted shr rot.AsInteger) or (xorshifted shl ((-rot) and
    BigInteger(31)).AsInteger);
  Result := answer and mask32;
end;

function TPCG32.NextIntRange(size: Integer): TArray<BigInteger>;
var
  i: Integer;
begin
  SetLength(Result, size);
  if size = 0 then
    exit;

  for i := 0 to size - 1 do
    Result[i] := NextInt;
end;

procedure TPCG32.Seed(seed_state, seed_sequence: BigInteger);
begin
  FState := 0;
  FInc := ((seed_sequence shl 1) or 1) and mask64;
  nextint();
  Fstate := (Fstate + seed_state);
  nextint();
end;

var
  PCG32: TPCG32;
  i, key: Integer;
  count: TDictionary<Integer, Integer>;

begin
  PCG32 := TPCG32.Create(42, 54);

  for i := 0 to 4 do
    Writeln(PCG32.NextInt().ToString);

  PCG32.seed(987654321, 1);

  count := TDictionary<Integer, Integer>.Create();

  for i := 1 to 100000 do
  begin
    key := Trunc(PCG32.NextFloat * 5);
    if count.ContainsKey(key) then
      count[key] := count[key] + 1
    else
      count.Add(key, 1);
  end;

  Writeln(#10'The counts for 100,000 repetitions are:');

  for key in count.Keys do
    Writeln(key, ' : ', count[key]);

  count.free;
  PCG32.free;
  Readln;
end.
