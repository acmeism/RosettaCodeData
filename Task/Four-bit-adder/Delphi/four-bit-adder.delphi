program Four_bit_adder;

{$APPTYPE CONSOLE}

uses
  System.SysUtils;

Type
  TBitAdderOutput = record
    S, C: Boolean;
    procedure Assign(_s, _C: Boolean);
    function ToString: string;
  end;

  TNibbleBits = array[1..4] of Boolean;

  TNibble = record
    Bits: TNibbleBits;
    procedure Assign(_Bits: TNibbleBits); overload;
    procedure Assign(value: byte); overload;
    function ToString: string;
  end;

  TFourBitAdderOutput = record
    N: TNibble;
    c: Boolean;
    procedure Assign(_c: Boolean; _N: TNibbleBits);
    function ToString: string;
  end;

  TLogic = record
    class function GateNot(const A: Boolean): Boolean; static;
    class function GateAnd(const A, B: Boolean): Boolean; static;
    class function GateOr(const A, B: Boolean): Boolean; static;
    class function GateXor(const A, B: Boolean): Boolean; static;
  end;

  TConstructiveBlocks = record
    function HalfAdder(const A, B: Boolean): TBitAdderOutput;
    function FullAdder(const A, B, CI: Boolean): TBitAdderOutput;
    function FourBitAdder(const A, B: TNibble; const CI: Boolean): TFourBitAdderOutput;
  end;



{ TBitAdderOutput }

procedure TBitAdderOutput.Assign(_s, _C: Boolean);
begin
  s := _s;
  c := _C;
end;

function TBitAdderOutput.ToString: string;
begin
  Result := 'S' + ord(s).ToString + 'C' + ord(c).ToString;
end;

{ TNibble }

procedure TNibble.Assign(_Bits: TNibbleBits);
var
  i: Integer;
begin
  for i := 1 to 4 do
    Bits[i] := _Bits[i];
end;

procedure TNibble.Assign(value: byte);
var
  i: Integer;
begin
  value := value and $0F;
  for i := 1 to 4 do
    Bits[i] := ((value shr (i - 1)) and 1) = 1;
end;

function TNibble.ToString: string;
var
  i: Integer;
begin
  Result := '';
  for i := 4 downto 1 do
    Result := Result + ord(Bits[i]).ToString;
end;

{ TFourBitAdderOutput }

procedure TFourBitAdderOutput.Assign(_c: Boolean; _N: TNibbleBits);
begin
  N.Assign(_N);
  c := _c;
end;

function TFourBitAdderOutput.ToString: string;
begin
  Result := N.ToString + ' c=' + ord(c).ToString;
end;

{ TLogic }

class function TLogic.GateAnd(const A, B: Boolean): Boolean;
begin
  Result := A and B;
end;

class function TLogic.GateNot(const A: Boolean): Boolean;
begin
  Result := not A;
end;

class function TLogic.GateOr(const A, B: Boolean): Boolean;
begin
  Result := A or B;
end;

class function TLogic.GateXor(const A, B: Boolean): Boolean;
begin
  Result := GateOr(GateAnd(A, GateNot(B)), (GateAnd(GateNot(A), B)));
end;

{ TConstructiveBlocks }

function TConstructiveBlocks.FourBitAdder(const A, B: TNibble; const CI: Boolean):
  TFourBitAdderOutput;
var
  FA: array[1..4] of TBitAdderOutput;
  i: Integer;
begin
  FA[1] := FullAdder(A.Bits[1], B.Bits[1], CI);
  Result.N.Bits[1] := FA[1].S;

  for i := 2 to 4 do
  begin
    FA[i] := FullAdder(A.Bits[i], B.Bits[i], FA[i - 1].C);
    Result.N.Bits[i] := FA[i].S;
  end;
  Result.C := FA[4].C;
end;

function TConstructiveBlocks.FullAdder(const A, B, CI: Boolean): TBitAdderOutput;
var
  HA1, HA2: TBitAdderOutput;
begin
  HA1 := HalfAdder(CI, A);
  HA2 := HalfAdder(HA1.S, B);
  Result.Assign(HA2.S, TLogic.GateOr(HA1.C, HA2.C));
end;

function TConstructiveBlocks.HalfAdder(const A, B: Boolean): TBitAdderOutput;
begin
  Result.Assign(TLogic.GateXor(A, B), TLogic.GateAnd(A, B));
end;

var
  j, k: Integer;
  A, B: TNibble;
  Blocks: TConstructiveBlocks;

begin
  for k := 0 to 255 do
  begin
    A.Assign(0);
    B.Assign(0);
    for j := 0 to 7 do
    begin
      if j < 4 then
        A.Bits[j + 1] := ((1 shl j) and k) > 0
      else
        B.Bits[j + 1 - 4] := ((1 shl j) and k) > 0;
    end;

    write(A.ToString, ' + ', B.ToString, ' = ');
    Writeln(Blocks.FourBitAdder(A, B, false).ToString);
  end;
  Writeln;
  Readln;
end.
