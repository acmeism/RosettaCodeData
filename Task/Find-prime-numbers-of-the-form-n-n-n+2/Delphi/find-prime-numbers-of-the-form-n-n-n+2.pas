program Find_prime_numbers_of_the_form_n_n_n_plus_2;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  PrimTrial;

function Commatize(n: NativeInt): string;
var
  fmt: TFormatSettings;
begin
  fmt := TFormatSettings.Create('en-Us');
  Result := double(n).ToString(ffNumber, 64, 0, fmt);
end;

const
  limit = 200;

begin
  for var n := 1 to limit - 1 do
  begin
    var p := n * n * n + 2;
    if isPrime(p) then
      writeln('n = ', n: 3, ' => n^3 + 2 = ', Commatize(p): 9);
  end;
  readln;
end.
