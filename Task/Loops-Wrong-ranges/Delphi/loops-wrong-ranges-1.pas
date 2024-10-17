program Wrong_ranges;

{$APPTYPE CONSOLE}

uses
  System.SysUtils;

procedure Example(start, stop, Increment: Integer; comment: string);
var
  MAX_ITER, iteration, i: Integer;
begin
  Write((comment + ' ').PadRight(50, '-') + ' ');
  MAX_ITER := 9;
  iteration := 0;

  if Increment = 1 then
  begin
    for i := start to stop do
    begin
      Write(i: 2, ' ');
      inc(iteration);
      if iteration >= MAX_ITER then
        Break;
    end;
    Writeln;
    exit;
  end;

  if Increment = -1 then
  begin
    for i := start downto stop do
    begin
      Write(i: 2, ' ');
      inc(iteration);
      if iteration >= MAX_ITER then
        Break;
    end;
    Writeln;
    exit;
  end;

  Writeln('Not supported');
end;

begin
  Example(-2, 2, 1, 'Normal');
  Example(-2, 2, 0, 'Zero increment');
  Example(-2, 2, -1, 'Increments away from stop value');
  Example(-2, 2, 10, 'First increment is beyond stop value');
  Example(2, -2, 1, 'Start more than stop: positive increment');
  Example(2, 2, 1, 'Start equal stop: positive increment');
  Example(2, 2, -1, 'Start equal stop: negative increment');
  Example(2, 2, 0, 'Start equal stop: zero increment');
  Example(0, 0, 0, 'Start equal stop equal zero: zero increment');
  Readln;
end.
