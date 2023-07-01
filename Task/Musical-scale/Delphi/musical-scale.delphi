program Musical_scale;

{$APPTYPE CONSOLE}

uses
  Winapi.Windows;

var
  notes: TArray<Double> = [261.63, 293.66, 329.63, 349.23, 392.00, 440.00,
    493.88, 523.25];

begin
  for var note in notes do
    Beep(Round(note), 500);
  readln;
end.
