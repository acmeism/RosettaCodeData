program LastFridayOfMonth;

{$APPTYPE CONSOLE}

uses
  System.SysUtils, System.DateUtils;

var
  Year: Word;
  Month: Word;
  D1: TDateTime;
  D2: Word;

begin
  Write('Enter year: ');
  ReadLn(Year);

  for Month := MonthJanuary to MonthDecember do begin
    D1 := EndOfAMonth(Year, Month);
    D2 := DayOfTheWeek(D1);
    while D2 <> DayFriday do begin
      D1 := IncDay(D1, -1);
      D2 := DayOfTheWeek(D1);
    end;
    WriteLn(DateToStr(D1));
  end;
end.
