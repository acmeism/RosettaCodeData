program Fast_Fourier_transform;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.VarCmplx,
  System.Math;

function BitReverse(n: UInt64; bits: Integer): UInt64;
var
  count, reversedN: UInt64;
begin
  reversedN := n;
  count := bits - 1;

  n := n shr 1;

  while n > 0 do
  begin
    reversedN := (reversedN shl 1) or (n and 1);
    dec(count);
    n := n shr 1;
  end;

  Result := ((reversedN shl count) and ((1 shl bits) - 1));
end;

procedure FFT(var buffer: TArray<Variant>);
var
  j, bits: Integer;
  tmp: Variant;
begin
  bits := Trunc(Log2(length(buffer)));

  for j := 1 to High(buffer) do
  begin
    var swapPos := BitReverse(j, bits);
    if swapPos <= j then
      Continue;

    tmp := buffer[j];
    buffer[j] := buffer[swapPos];
    buffer[swapPos] := tmp;
  end;

  var N := 2;
  while N <= Length(buffer) do
  begin
    var i := 0;
    while i < Length(buffer) do
    begin
      for var k := 0 to N div 2 - 1 do
      begin
        var evenIndex := i + k;
        var oddIndex := i + k + (N div 2);
        var _even := buffer[evenIndex];
        var _odd := buffer[oddIndex];
        var term := -2 * PI * k / N;
        var _exp := VarComplexCreate(Cos(term), Sin(term)) * _odd;

        buffer[evenIndex] := _even + _exp;
        buffer[oddIndex] := _even - _exp;
      end;
      i := i + N;
    end;
    N := N shl 1;
  end;

end;

const
  input: array of Double = [1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0];

var
  inputc: TArray<Variant>;

begin
  SetLength(inputc, length(input));
  for var i := 0 to High(input) do
    inputc[i] := VarComplexCreate(input[i]);

  FFT(inputc);

  for var c in inputc do
    writeln(c);
  readln;
end.
