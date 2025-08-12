program Old_Russian_measure_of_length;

{$APPTYPE CONSOLE}

uses
  System.SysUtils;

const
  units: array[0..12] of string = ('tochka', 'liniya', 'dyuim', 'vershok',
    'piad', 'fut', 'arshin', 'sazhen', 'versta', 'milia', 'centimeter', 'meter',
    'kilometer');
  convs: array[0..12] of double = (0.0254, 0.254, 2.54, 4.445, 17.78, 30.48,
    71.12, 213.36, 106680, 746760, 1, 100, 100000);

function ReadInt(): integer;
var
  data: string;
begin
  Readln(data);
  Result := StrToIntDef(data, -1);
end;

function ReadFloat(): Double;
var
  data: string;
begin
  Readln(data);
  Result := StrToFloatDef(data, -1);
end;

var
  yn, u: string;
  i, unt: integer;
  value: Double;

begin

  repeat
    for i := 0 to High(units) do
    begin
      u := units[i];
      Writeln(format('%2d %s', [i + 1, u]));
    end;
    Writeln;

    unt := 0;
    repeat
      Writeln('Please choose a unit 1 to 13 : ');
      unt := ReadInt();
    until (unt >= 1) and (unt <= 13);

    dec(unt);

    repeat
      Writeln('Now enter a value in that unit : ');
      value := ReadFloat();
    until value >= 0;

    Writeln(#10'The equivalent in the remaining units is:'#10);

    for i := 0 to High(units) do
    begin
      u := units[i];
      if i = unt then
        Continue;
      Writeln(format(' %10s : %g', [u, value * convs[unt] / convs[i]]));
    end;

    Writeln;

    yn := '';
    Writeln('Do another one y/n : ');
    readln(yn);
  until yn.toLower = 'n';
end.
