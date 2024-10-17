program Y;

{$APPTYPE CONSOLE}

uses
  SysUtils;

type
  YCombinator = class sealed
    class function Fix<T> (F: TFunc<TFunc<T, T>, TFunc<T, T>>): TFunc<T, T>; static;
  end;

  TRecursiveFuncWrapper<T> = record // workaround required because of QC #101272 (http://qc.embarcadero.com/wc/qcmain.aspx?d=101272)
    type
      TRecursiveFunc = reference to function (R: TRecursiveFuncWrapper<T>): TFunc<T, T>;
    var
      O: TRecursiveFunc;
  end;

class function YCombinator.Fix<T> (F: TFunc<TFunc<T, T>, TFunc<T, T>>): TFunc<T, T>;
var
  R: TRecursiveFuncWrapper<T>;
begin
  R.O := function (W: TRecursiveFuncWrapper<T>): TFunc<T, T>
    begin
      Result := F (function (I: T): T
        begin
          Result := W.O (W) (I);
        end);
    end;
  Result := R.O (R);
end;


type
  IntFunc = TFunc<Integer, Integer>;

function AlmostFac (F: IntFunc): IntFunc;
begin
  Result := function (N: Integer): Integer
    begin
      if N <= 1 then
        Result := 1
      else
        Result := N * F (N - 1);
    end;
end;

function AlmostFib (F: TFunc<Integer, Integer>): TFunc<Integer, Integer>;
begin
  Result := function (N: Integer): Integer
    begin
      if N <= 2 then
        Result := 1
      else
        Result := F (N - 1) + F (N - 2);
    end;
end;

var
  Fib, Fac: IntFunc;
begin
  Fib := YCombinator.Fix<Integer> (AlmostFib);
  Fac := YCombinator.Fix<Integer> (AlmostFac);
  Writeln ('Fib(10) = ', Fib (10));
  Writeln ('Fac(10) = ', Fac (10));
end.
