program Accumulator_factory;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Variants;

type
  TFn = TFunc<variant, variant>;

function Foo(n: variant): TFn;
begin
  Result :=
    function(i: variant): variant
    begin
      n:= n + i;
      Result := n;
    end;
end;

begin
  var x := Foo(1);
  x(5);
  Foo(3); // do nothing
  Writeln(x(2.3));
  Readln;
end.
