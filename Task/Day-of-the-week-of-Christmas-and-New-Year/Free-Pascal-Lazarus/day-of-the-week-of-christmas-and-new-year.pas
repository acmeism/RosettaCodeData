Program daysofweek;
Uses sysutils;

Const Years : array Of integer = (1578, 1590, 1642, 1957, 2020, 2021, 2022, 2242, 2245, 2393);

Var christmasday, newyearsday : tdatetime;
  year : integer;
Begin
  For year In years Do
    Begin
      christmasday := encodeDate(year,12,25);
      newyearsday := encodeDate(year,1,1);
      writeln('in ',year,' New Years day is on ',DefaultFormatSettings.LongDayNames[DayOfWeek(
              newyearsday)],', and Christmas day on a ',DefaultFormatSettings.LongDayNames[DayOfWeek(
                                                                                        christmasday
      )]);
    End;
End.
