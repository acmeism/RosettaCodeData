program Long_year;

uses
  SysUtils,
  DateUtils;

  procedure PrintLongYears(StartYear, EndYear: Uint32);
  var
    Year, Count: Uint32;
    DateSep: char;
  begin
    DateSep := FormatSettings.DateSeparator;
    Writeln('Long years between ', StartYear, ' and ', EndYear);
    Count := 0;
    for Year := StartYear to EndYear do
      if WeeksInYear(StrToDate('01' + DateSep + '01' + DateSep + IntToStr(Year))) = 53 then
      begin
        if Count mod 10 = 0 then
          Writeln;
        Write(Year, ' ');
        Inc(Count);
      end;
    if Count mod 10 <> 0 then
      Writeln;
    writeln('Found ', Count, ' long years between ', StartYear, ' and ', EndYear);
  end;

begin
  PrintLongYears(1800, 2100);
  {$IFDEF WINDOWS}
  Readln;
  {$ENDIF}
end.
