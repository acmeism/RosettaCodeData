program Metronome;

{$APPTYPE CONSOLE}

uses
  Winapi.Windows,
  System.SysUtils;

procedure StartMetronome(bpm: double; measure: Integer);
var
  counter: Integer;
begin
  counter := 0;
  while True do
  begin
    Sleep(Trunc(1000 * (60.0 / bpm)));
    inc(counter);
    if counter mod measure = 0 then
      writeln('TICK')
    else
      writeln('TOCK');
  end;
end;

begin
  StartMetronome(120, 4);
end.
