program Set_of_real_numbers;

{$APPTYPE CONSOLE}

uses
  System.SysUtils;

type
  TSet = TFunc<Double, boolean>;

function Union(a, b: TSet): TSet;
begin
  Result :=
    function(x: double): boolean
    begin
      Result := a(x) or b(x);
    end;
end;

function Inter(a, b: TSet): TSet;
begin
  Result :=
    function(x: double): boolean
    begin
      Result := a(x) and b(x);
    end;
end;

function Diff(a, b: TSet): TSet;
begin
  Result :=
    function(x: double): boolean
    begin
      Result := a(x) and not b(x);
    end;
end;

function Open(a, b: double): TSet;
begin
  Result :=
    function(x: double): boolean
    begin
      Result := (a < x) and (x < b);
    end;
end;

function closed(a, b: double): TSet;
begin
  Result :=
    function(x: double): boolean
    begin
      Result := (a <= x) and (x <= b);
    end;
end;

function opCl(a, b: double): TSet;
begin
  Result :=
    function(x: double): boolean
    begin
      Result := (a < x) and (x <= b);
    end;
end;

function clOp(a, b: double): TSet;
begin
  Result :=
    function(x: double): boolean
    begin
      Result := (a <= x) and (x < b);
    end;
end;

const
  BOOLSTR: array[Boolean] of string = ('False', 'True');

begin
  var s: TArray<TSet>;
  SetLength(s, 4);

  s[0] := Union(opCl(0, 1), clOp(0, 2));  // (0,1] ? [0,2)
  s[1] := Inter(clOp(0, 2), opCl(1, 2));  // [0,2) n (1,2]
  s[2] := Diff(clOp(0, 3), open(0, 1));   // [0,3) - (0,1)
  s[3] := Diff(clOp(0, 3), closed(0, 1)); // [0,3) - [0,1]

  for var i := 0 to High(s) do
  begin
    for var x := 0 to 2 do
      writeln(format('%d e s%d: %s', [x, i, BOOLSTR[s[i](x)]]));
    writeln;
  end;
  readln;
end.
