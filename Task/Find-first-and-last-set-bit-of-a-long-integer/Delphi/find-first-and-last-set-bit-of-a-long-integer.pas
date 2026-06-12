program Find_first_and_last_set_bit_of_a_long_integer;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  Velthuis.BigIntegers;

function bsf(x: string): Integer;
begin
  Result := x.Length - x.LastIndexOf('1') - 1;
end;

function bsr(x: string): Integer;
begin
  Result := x.Length - x.IndexOf('1') - 1;
end;

var
  i: integer;
  value: BigInteger;
  binary: string;

begin
  for i := 0 to 11 do
  begin
    value := BigInteger.Pow(42, i);
    binary := value.ToBinaryString.PadLeft(64, '0');

    Writeln(format('%18s %60s MSB: %2d LSB: %2d', [value.ToString, binary, bsr(binary),
      bsf(binary)]));
  end;

  readln;
end.
