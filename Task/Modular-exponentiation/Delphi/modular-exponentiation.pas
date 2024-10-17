program Modular_exponentiation;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  Velthuis.BigIntegers;

var
  a, b, m: BigInteger;

begin
  a := BigInteger.Parse('2988348162058574136915891421498819466320163312926952423791023078876139');
  b := BigInteger.Parse('2351399303373464486466122544523690094744975233415544072992656881240319');
  m := BigInteger.Pow(10, 40);
  Writeln(BigInteger.ModPow(a, b, m).ToString);
  readln;
end.
