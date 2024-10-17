program FiveWeekends;

{$APPTYPE CONSOLE}

uses SysUtils, DateUtils;

var
  lMonth, lYear: Integer;
  lDate: TDateTime;
  lFiveWeekendCount: Integer;
  lYearsWithout: Integer;
  lFiveWeekendFound: Boolean;
begin
  for lYear := 1900 to 2100 do
  begin
    lFiveWeekendFound := False;
    for lMonth := 1 to 12 do
    begin
      lDate := EncodeDate(lYear, lMonth, 1);
      if (DaysInMonth(lDate) = 31) and (DayOfTheWeek(lDate) = DayFriday) then
      begin
        Writeln(FormatDateTime('mmm yyyy', lDate));
        Inc(lFiveWeekendCount);
        lFiveWeekendFound := True;
      end;
    end;
    if not lFiveWeekendFound then
      Inc(lYearsWithout);
  end;

  Writeln;
  Writeln(Format('Months with 5 weekends: %d', [lFiveWeekendCount]));
  Writeln(Format('Years with no 5 weekend months: %d', [lYearsWithout]));
end.
