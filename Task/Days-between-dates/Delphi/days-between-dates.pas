program Days_between_dates;

{$APPTYPE CONSOLE}

uses
  System.SysUtils;

function CreateFormat(fmt: string; Delimiter: Char): TFormatSettings;
begin
  Result := TFormatSettings.Create();
  with Result do
  begin
    DateSeparator := Delimiter;
    ShortDateFormat := fmt;
  end;
end;

function DaysBetween(Date1, Date2: string): Integer;
var
  dt1, dt2: TDateTime;
  fmt: TFormatSettings;
begin
  fmt := CreateFormat('yyyy-mm-dd', '-');
  dt1 := StrToDate(Date1, fmt);
  dt2 := StrToDate(Date2, fmt);
  Result := Trunc(dt2 - dt1);
end;

begin
  Writeln(DaysBetween('1970-01-01', '2019-10-18'));
  readln;
end.
