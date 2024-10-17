program Arbitrary_precision_integers;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  Velthuis.BigIntegers;

var
  value: BigInteger;
  result: string;

begin
  value := BigInteger.pow(3, 2);
  value := BigInteger.pow(4, value.AsInteger);
  value := BigInteger.pow(5, value.AsInteger);
  result := value.tostring;
  Write('5^4^3^2 = ');
  Write(result.substring(0, 20), '...');
  Write(result.substring(result.length - 20, 20));
  Writeln(' (', result.Length,' digits)');
  readln;
end.
