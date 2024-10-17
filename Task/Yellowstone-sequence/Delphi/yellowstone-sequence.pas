program Yellowstone_sequence;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  Boost.Generics.Collection,
  Boost.Process;

function gdc(x, y: Integer): Integer;
begin
  while y <> 0 do
  begin
    var tmp := x;
    x := y;
    y := tmp mod y;
  end;
  Result := x;
end;

function Yellowstone(n: Integer): TArray<Integer>;
var
  m: TDictionary<Integer, Boolean>;
  a: TArray<Integer>;
begin
  m.Init;
  SetLength(a, n + 1);
  for var i := 1 to 3 do
  begin
    a[i] := i;
    m[i] := True;
  end;

  var min := 4;

  for var c := 4 to n do
  begin
    var i := min;
    repeat
      if not m[i, false] and (gdc(a[c - 1], i) = 1) and (gdc(a[c - 2], i) > 1) then
      begin
        a[c] := i;
        m[i] := true;
        if i = min then
          inc(min);
        Break;
      end;
      inc(i);
    until false;
  end;

  Result := copy(a, 1, length(a));
end;

begin
  var x: TArray<Integer>;
  SetLength(x, 100);
  for var i in Range(100) do
    x[i] := i + 1;

  var y := yellowstone(High(x));

  writeln('The first 30 Yellowstone numbers are:');
  for var i := 0 to 29 do
    Write(y[i], ' ');
  Writeln;

  //Plotting

  var plot := TPipe.Create('gnuplot -p', True);
  plot.WritelnA('unset key; plot ''-''');

  for var i := 0 to High(x) do
    plot.WriteA('%d %d'#10, [x[i], y[i]]);
  plot.WritelnA('e');

  writeln('Press enter to close');
  Readln;
  plot.Kill;
  plot.Free;
end.
