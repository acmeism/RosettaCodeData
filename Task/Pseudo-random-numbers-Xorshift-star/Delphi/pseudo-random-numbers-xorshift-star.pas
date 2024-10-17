program Xorshift_star;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Math;

type
  TXorshiftStar = record
  private
    state: uint64;
    const
      k = $2545F4914F6CDD1D;
  public
    constructor Create(aState: uint64);
    procedure Seed(aState: uint64);
    function NextInt: uint32;
    function NextFloat: Extended;
  end;

{ TXorshiftStar }

constructor TXorshiftStar.Create(aState: uint64);
begin
  Seed(aState);
end;

function TXorshiftStar.NextFloat: Extended;
begin
  Result := NextInt() / $100000000;
end;

function TXorshiftStar.NextInt: uint32;
var
  x: UInt64;
begin
  x := state;
  x := x xor (x shr 12);
  x := x xor (x shl 25);
  x := x xor (x shr 27);
  state := x;
  Result := uint32((x * k) shr 32);
end;

procedure TXorshiftStar.Seed(aState: uint64);
begin
  state := aState;
end;

begin
  var randomGen := TXorshiftStar.Create(1234567);

  for var i := 0 to 4 do
    writeln(randomGen.NextInt);

  var counts := [0, 0, 0, 0, 0];
  randomGen.seed(987654321);

  for var i := 1 to 100000 do
  begin
    var j := Floor(randomGen.nextFloat() * 5);
    inc(counts[j]);
  end;

  writeln(#10'The counts for 100,000 repetitions are:');

  for var i := 0 to 4 do
    writeln(format(' %d : %d', [i, counts[i]]));

  {$IFNDEF UNIX} Readln; {$ENDIF}
end.
