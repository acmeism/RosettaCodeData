program RungeKuttaExample;

uses sysutils;

type
    TDerivative = function (t, y : Real) : Real;

procedure RungeKutta(yDer : TDerivative;
                     var t, y : array of Real;
                     dt   : Real);
var
    dy1, dy2, dy3, dy4 : Real;
    idx                : Cardinal;

begin
    for idx := Low(t) to High(t) - 1 do
    begin
        dy1 := dt * yDer(t[idx],            y[idx]);
        dy2 := dt * yDer(t[idx] + dt / 2.0, y[idx] + dy1 / 2.0);
        dy3 := dt * yDer(t[idx] + dt / 2.0, y[idx] + dy2 / 2.0);
        dy4 := dt * yDer(t[idx] + dt,       y[idx] + dy3);

        t[idx + 1] := t[idx] + dt;
        y[idx + 1] := y[idx] + (dy1 + 2.0 * (dy2 + dy3) + dy4) / 6.0;
    end;
end;

function CalcError(t, y : Real) : Real;
var
    trueVal : Real;

begin
    trueVal := sqr(sqr(t) + 4.0) / 16.0;
    CalcError := abs(trueVal - y);
end;

procedure Print(t, y : array of Real;
                modnum : Integer);
var
    idx : Cardinal;

begin
    for idx := Low(t) to High(t) do
    begin
        if idx mod modnum = 0 then
        begin
            WriteLn(Format('y(%4.1f) = %12.8f  Error: %12.6e',
                [t[idx], y[idx], CalcError(t[idx], y[idx])]));
        end;
    end;
end;

function YPrime(t, y : Real) : Real;
begin
    YPrime := t * sqrt(y);
end;

const
    dt = 0.10;
    N = 100;

var
    tArr, yArr : array [0..N] of Real;

begin
    tArr[0] := 0.0;
    yArr[0] := 1.0;

    RungeKutta(@YPrime, tArr, yArr, dt);
    Print(tArr, yArr, 10);
end.
