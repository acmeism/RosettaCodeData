program Pathological_floating_point_problems;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  Velthuis.BigIntegers,
  Velthuis.BigRationals,
  Velthuis.BigDecimals;

type
  TBalance = record
    e, d: BigInteger;
  end;

procedure Sequence(Precision: Integer);
var
  v, v1, c111, c1130, c3000, t2, t3: BigRational;
  n: integer;
begin
  BigDecimal.DefaultPrecision := Precision;
  v1 := 2;
  v := -4;
  n := 2;
  c111 := BigRational(111);
  c1130 := BigRational(1130);
  c3000 := BigRational(3000);

  var r :=
    function(): BigRational
    begin
      t3 := v * v1;
      t3 := BigRational.Create(BigDecimal.Divide(c3000, t3));
      t2 := BigRational.Create(BigDecimal.Divide(c1130, v));
      result := c111 - t2;
      result := result + t3;
    end;

  writeln('  n  sequence value');

  for var x in [3, 4, 5, 6, 7, 8, 20, 30, 50, 100] do
  begin
    while n < x do
    begin
      var tmp := BigRational.Create(v);
      v := BigRational.Create(r());
      v1 := BigRational.Create(tmp);
      inc(n);
    end;

    var f := double(v);
    writeln(format('%3d %19.16f', [n, f]));
  end;
end;

procedure Bank();
var
  balance: TBalance;
  m, one, ef, df: BigInteger;
  e, b: BigDecimal;
begin
  balance.e := 1;
  balance.d := -1;
  one := BigInteger.One;

  for var y := 1 to 25 do
  begin
    m := y;
    balance.e := m * balance.e;
    balance.d := m * balance.d;
    balance.d := balance.d - one;
  end;

  e := BigDecimal.Create('2.71828182845904523536028747135');

  ef := balance.e;
  df := balance.d;

  b := e * ef;
  b := b + df;

  writeln(format('Bank balance after 25 years: $%.2f', [b.AsDouble]));
end;

function f(a, b: Double): Double;
var
  a1, a2, b1, b2, b4, b6, b8, two, t1, t21, t2, t3, t4, t23: BigDecimal;
begin
  var fp :=
    function(x: double): BigDecimal
    begin
      Result := BigDecimal.Create(x);
    end;

  a1 := fp(a);
  b1 := fp(b);
  a2 := a1 * a1;
  b2 := b1 * b1;
  b4 := b2 * b2;
  b6 := b2 * b4;
  b8 := b4 * b4;

  two := fp(2);
  t1 := fp(333.75);
  t1 := t1 * b6;
  t21 := fp(11);
  t21 := t21 * a2 * b2;
  t23 := fp(121);
  t23 := t23 * b4;

  t2 := t21 - b6;
  t2 := (t2 - t23) - two;
  t2 := a2 * t2;

  t3 := fp(5.5);
  t3 := t3 * b8;

  t4 := two * b1;
  t4 := a1 / t4;

  var s := t1 + t2;
  s := s + t3;
  s := s + t4;
  result := s.AsDouble;
end;

procedure Rump();
var
  a, b: Double;
begin
  a := 77617;
  b := 33096;
  writeln(format('Rump f(%g, %g): %g', [a, b, f(a, b)]));
end;

{ TBigRationalHelper }


begin
  for var Precision in [100, 200] do
  begin
    writeln(#10'Precision: ', Precision);
    sequence(Precision);
    bank();
    rump();
  end;

  readln;
end.
