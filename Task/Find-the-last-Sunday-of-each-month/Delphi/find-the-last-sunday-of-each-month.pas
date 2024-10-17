program Find_the_last_Sunday_of_each_month;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.DateUtils;

// ADayOfWeek -> sunday is the first day and is 1
function LastDayOfWeekOfEachMonth(AYear, ADayOfWeek: Word): TArray<TDateTime>;
var
  month: word;
  daysOffset: Integer;
  date: TDatetime;
begin
  if (ADayOfWeek > 7) or (ADayOfWeek < 1) then
    raise Exception.CreateFmt('Error on FindAllDaysOfWeek: "%d" must be in [1..7] (sun..sat)',
      [ADayOfWeek]);

  SetLength(Result, 12);

  for month := 1 to 12 do
  begin
    date := EncodeDate(AYear, month, DaysInAMonth(AYear, month));

    daysOffset := DayOfWeek(date) - ADayOfWeek;
    if daysOffset < 0 then
      inc(daysOffset, 7);

    Result[month - 1] := date - daysOffset;
  end;
end;

var
  strYear: string;
  Year: Integer;
  date: TDateTime;

begin
  write('Year to calculate: ');
  Readln(strYear);
  if not TryStrToInt(strYear, Year) or (Year < 1900) then
    raise Exception.CreateFmt('Error: "%s" is not a valid year', [strYear]);

  for date in LastDayOfWeekOfEachMonth(Year, 1) do
    writeln(FormatDateTime('yyyy-mmm-dd', date));

  readln;
end.
