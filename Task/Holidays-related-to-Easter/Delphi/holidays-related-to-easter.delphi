program Holidays_related_to_Easter;

{$APPTYPE CONSOLE}

uses
  System.SysUtils;

type
  THollyday = record
    name: string;
    offs: Integer;
  end;

const
  Holyday: array[0..4] of THollyday = ((
    name: 'Easter';
    offs: 0
  ), (
    name: 'Ascension';
    offs: 39
  ), (
    name: 'Pentecost';
    offs: 10
  ), (
    name: 'Trinity';
    offs: 7
  ), (
    name: 'Corpus';
    offs: 4
  ));

function Easter(year: Integer): TDateTime;
begin
  var a := year mod 19;
  var b := year div 100;
  var c := year mod 100;
  var d := b div 4;
  var e := b mod 4;
  var f := (b + 8) div 25;
  var g := (b - f + 1) div 3;
  var h := (19 * a + b - d - g + 15) mod 30;
  var i := c div 4;
  var k := c mod 4;
  var l := (32 + 2 * e + 2 * i - h - k) mod 7;
  var m := (a + 11 * h + 22 * l) div 451;
  var n := h + l - 7 * m + 114;
  var month := n div 31;
  var day := (n mod 31) + 1;

  Result := EncodeDate(year, month, day);
end;

procedure PrintEasterRelatedHolidays(year: Integer);
var
  y, m, d: word;
  fmt: TFormatSettings;
begin
  fmt := TFormatSettings.Create('en-US'); // just for use english name of month
  var date := Easter(year);
  write(year: 4, ' ');
  for var hd in Holyday do
  begin
    date := date + hd.offs;
    var dt := FormatDateTime('dd mmmm', date, fmt);
    write(format('%s: %s  ', [hd.name, dt]));
  end;
  writeln;
end;

begin
  writeln('Christian holidays, related to Easter,' +
    ' for each centennial from 400 to 2100 CE:');
  for var y := 4 to 21 do
    printEasterRelatedHolidays(y * 100);

  writeln(#10'Christian holidays, related to Easter,' +
    ' for years from 2010 to 2020 CE:');

  for var y := 2010 to 2020 do
    printEasterRelatedHolidays(y);
  readln;
end.
