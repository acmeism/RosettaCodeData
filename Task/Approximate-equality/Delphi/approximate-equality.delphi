program Approximate_Equality;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Math;

const
  EPSILON: Double = 1E-18;

procedure Test(a, b: Double; Expected: Boolean);
var
  result: Boolean;
const
  STATUS: array[Boolean] of string = ('FAIL', 'OK');
begin
  result := SameValue(a, b, EPSILON);
  Write(a, ' ', b, ' => ', result, ' '^I);
  writeln(Expected, ^I, STATUS[Expected = result]);
end;

begin
  Test(100000000000000.01, 100000000000000.011, True);
  Test(100.01, 100.011, False);
  Test(double(10000000000000.001) / double(10000.0), double(1000000000.0000001000),
    False);
  Test(0.001, 0.0010000001, False);
  Test(0.000000000000000000000101, 0.0, True);
  Test(double(Sqrt(2)) * double(Sqrt(2)), 2.0, False);
  Test(-double(Sqrt(2)) * double(Sqrt(2)), -2.0, false);
  Test(3.14159265358979323846, 3.14159265358979324, True);
  Readln;
end.
