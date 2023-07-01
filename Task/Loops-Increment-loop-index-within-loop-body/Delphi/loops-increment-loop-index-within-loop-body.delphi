program Increment_loop_index_within_loop_body;

{$APPTYPE CONSOLE}

uses
  System.SysUtils;

function IsPrime(const a: UInt64): Boolean;
var
  d: UInt64;
begin
  if (a < 2) then
    exit(False);

  if (a mod 2) = 0 then
    exit(a = 2);

  if (a mod 3) = 0 then
    exit(a = 3);

  d := 5;

  while (d * d <= a) do
  begin
    if (a mod d = 0) then
      Exit(false);
    inc(d, 2);

    if (a mod d = 0) then
      Exit(false);
    inc(d, 4);
  end;

  Result := True;
end;

var
  i, n: UInt64;

begin
  FormatSettings.ThousandSeparator:= ',';
  i := 42;
  n := 0;
  while (n < 42) do
  begin
    if (isPrime(i)) then
    begin
      inc(n);
      Writeln('n = ', n: -20, ' ', floattostrF(i, ffNumber, 20,0):20);
      i := 2 * i - 1;
    end;
    inc(i);
  end;
  readln;
end.
