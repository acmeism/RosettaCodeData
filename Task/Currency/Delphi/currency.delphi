program Currency;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  Velthuis.BigRationals,
  Velthuis.BigDecimals,
  Velthuis.BigIntegers;

var
  one: BigInteger;
  hundred: BigInteger;
  half: BigRational;

type
  TDc = record
    value: BigInteger;
    function ToString: string;
    function Extend(n: BigInteger): TDc;
    class operator Add(a, b: TDc): TDc;
  end;

  TTR = record
    value: BigRational;
    function SetString(const s: string; var TR: TTR): boolean;
    function Tax(dc: TDc): TDc;
  end;

{ TDc }

// Extend returns extended price of a unit price.
class operator TDc.Add(a, b: TDc): TDc;
begin
  Result.value := a.value + b.value;
end;

function TDc.Extend(n: BigInteger): TDc;
begin
  Result.value := n * value;
end;

function TDc.ToString: string;
var
  d: BigInteger;
begin
  d := value.Divide(value, 100);
  if value < 0 then
    value := -value;
  Result := Format('%s.%2s', [d.ToString, (value mod 100).ToString]);
end;

// ParseDC parses dollars and cents as a string into a DC.
function ParseDC(s: string; var Dc: TDc): Boolean;
var
  r: BigRational;
  d: BigDecimal;
begin
  Result := d.TryParse(s, d);
  if not Result then
  begin
    Dc.value := 0;
    exit(false);
  end;

  r := r.Create(d);
  r := r.Multiply(r, 100);
  if BigInteger.Compare(r.Denominator, 1) <> 0 then
  begin
    Dc.value := 0;
    exit(false);
  end;
  Result := true;
  Dc.value := r.Numerator;
end;

{ TTR }

function TTR.SetString(const s: string; var TR: TTR): boolean;
var
  d: BigDecimal;
begin

  Result := d.TryParse(s, d);
  if Result then
    TR.value := BigRational.Create(d);
end;

function TTR.Tax(dc: TDc): TDc;
var
  r: BigRational;
  i: BigInteger;
begin
  r := BigRational.Create(dc.value, 1);
  r := r.Multiply(r, self.value);
  r := r.add(r, half);
  i := i.Divide(r.Numerator, r.Denominator);
  Result.value := i;
end;

var
  hamburgerPrice, milkshakePrice, totalBeforeTax, tax, total: TDc;
  taxRate: TTR;

begin
  one := 1;
  hundred := 100;
  half := BigRational.Create(1, 2);

  if not ParseDC('5.50', hamburgerPrice) then
  begin
    Writeln('Invalid hamburger price');
    halt(1);
  end;

  if not ParseDC('2.86', milkshakePrice) then
  begin
    Writeln('Invalid milkshake price');
    halt(2);
  end;

  if not taxRate.SetString('0.0765', taxRate) then
  begin
    Writeln('Invalid tax rat');
    halt(3);
  end;

  totalBeforeTax := hamburgerPrice.Extend(4000000000000000) + milkshakePrice.Extend(2);
  tax := taxRate.Tax(totalBeforeTax);
  total := totalBeforeTax + tax;
  Writeln('Total before tax: ', totalBeforeTax.ToString: 22);
  Writeln('             Tax: ', tax.ToString: 22);
  Writeln('           Total: ', total.ToString: 22);
  readln;
end.
