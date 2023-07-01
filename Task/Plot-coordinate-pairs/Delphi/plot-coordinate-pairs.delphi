program Plot_coordinate_pairs;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  Boost.Process;

var
  x: TArray<Integer>;
  y: TArray<Double>;

begin
  x := [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
  y := [2.7, 2.8, 31.4, 38.1, 58.0, 76.2, 100.5, 130.0, 149.3, 180.0];

  var plot := TPipe.Create('gnuplot -p', True);
  plot.WriteA('unset key; plot ''-'''#10);
  for var i := 0 to High(x) do
    plot.WriteA(format('%d %f'#10, [x[i], y[i]]));
  plot.writeA('e'#10);

  writeln('Press enter to close');
  Readln;
  plot.Kill;
  plot.Free;
  readln;
end.
