program Legendre(output);

const Order   = 5;
      Order1 = Order - 1;
      Epsilon = 1E-12;
      Pi = 3.1415926;

var Roots   : array[0..Order1] of real;
    Weight  : array[0..Order1] of real;
    LegCoef : array [0..Order,0..Order] of real;
    I : integer;


function F(X:real) : real;
begin
  F := Exp(X);
end;

procedure PrepCoef;
var I, N : integer;
begin
  for I:=0 to Order do
    for N := 0 to Order do
      LegCoef[I,N] := 0;
  LegCoef[0,0] := 1;
  LegCoef[1,1] := 1;
  For N:=2 to Order do
    begin
      LegCoef[N,0] := -(N-1) * LegCoef[N-2,0] / N;
      For I := 1 to Order do
        LegCoef[N,I] := ((2*N-1) * LegCoef[N-1,I-1] - (N-1)*LegCoef[N-2,I]) / N;
    end;
end;

function LegEval(N:integer; X:real) : real;
var I : integer;
    Result : real;
begin
  Result := LegCoef[n][n];
  for I := N-1 downto 0 do
    Result := Result * X + LegCoef[N][I];
  LegEval := Result;
end;

function LegDiff(N:integer; X:real) : real;
begin
  LegDiff := N * (X * LegEval(N,X) - LegEval(N-1,X)) / (X*X-1);
end;

procedure LegRoots;
var I     : integer;
    X, X1 : real;
begin
  for I := 1 to Order do
    begin
      X := Cos(Pi * (I-0.25) / (Order+0.5));
        repeat
          X1 := X;
          X := X - LegEval(Order,X) / LegDiff(Order, X);
        until Abs (X-X1) < Epsilon;
      Roots[I-1] := X;
      X1 := LegDiff(Order,X);
      Weight[I-1] := 2 / ((1-X*X) * X1*X1);
    end;
end;

function LegInt(A,B:real) : real;
var I      : integer;
    C1, C2, Result : real;
begin
  C1 := (B-A)/2;
  C2 := (B+A)/2;
  Result := 0;
  For I := 0 to Order-1 do
    Result := Result + Weight[I] * F(C1*Roots[I] + C2);
  Result := C1 * Result;
  LegInt := Result;
end;

begin
  PrepCoef;
  LegRoots;

  Write('Roots:  ');
  for I := 0 to Order-1 do
    Write (' ',Roots[I]:13:10);
  Writeln;

  Write('Weight: ');
  for I := 0 to Order-1 do
    Write (' ', Weight[I]:13:10);
  writeln;

  Writeln('Integrating Exp(x) over [-3, 3]: ',LegInt(-3,3):13:10);
  Writeln('Actual value: ',Exp(3)-Exp(-3):13:10);
end.
