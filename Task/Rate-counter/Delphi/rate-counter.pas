program Rate_counter;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Diagnostics;

var
  a: Integer;

function TickToString(Tick: Int64): string;
var
  ns, us, ms, s, t: Cardinal;
begin
  Result := '';
  ns := (Tick mod 10) * 100;
  if ns > 0 then
    Result := format(' %dns', [ns]);

  t := Tick div 10;
  us := t mod 1000;
  if us > 0 then
    Result := format(' %dus', [us]) + Result;

  t := t div 1000;
  ms := t mod 1000;
  if ms > 0 then
    Result := format(' %dms', [ms]) + Result;

  t := t div 1000;
  s := t mod 1000;
  if s > 0 then
    Result := format(' %ds', [s]) + Result;
end;

function Benchmark(Fns: TArray<TProc>; times: Cardinal): TArray<string>;
var
  Stopwatch: TStopwatch;
  fn: TProc;
  i, j: Cardinal;
begin
  SetLength(result, length(Fns));
  Stopwatch := TStopwatch.Create;

  for i := 0 to High(Fns) do
  begin
    fn := Fns[i];
    if not Assigned(fn) then
      Continue;
    Stopwatch.Reset;
    Stopwatch.Start;
    for j := 1 to times do
      fn();
    Stopwatch.Stop;
    Result[i] := TickToString(Stopwatch.ElapsedTicks);
  end;
end;

procedure F0();
begin
end;

procedure F1();
begin
  var b := a;
end;

procedure F2();
begin
  var b := a.ToString;
end;

begin
  writeln('Time fx took to run 10,000 times:'#10);
  var r := Benchmark([F0, F1, F2], 10000);
  for var i := 0 to High(r) do
    writeln('f', i, ': ', r[i]);
  Readln;
end.
