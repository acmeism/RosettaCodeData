program DateManipulation;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  DateUtils;

function MonthNumber(aMonth: string): Word;
begin
  //Convert a string value representing the month
  //to its corresponding numerical value
  if aMonth = 'January' then Result:= 1
  else if aMonth = 'February' then Result:= 2
  else if aMonth = 'March' then Result:= 3
  else if aMonth = 'April' then Result:= 4
  else if aMonth = 'May' then Result:= 5
  else if aMonth = 'June' then Result:= 6
  else if aMonth = 'July' then Result:= 7
  else if aMonth = 'August' then Result:= 8
  else if aMonth = 'September' then Result:= 9
  else if aMonth = 'October' then Result:= 10
  else if aMonth = 'November' then Result:= 11
  else if aMonth = 'December' then Result:= 12
  else Result:= 12;
end;

function ParseString(aDateTime: string): TDateTime;
var
  strDay,
  strMonth,
  strYear,
  strTime: string;
  iDay,
  iMonth,
  iYear: Word;
  TimePortion: TDateTime;
begin
  //Decode the month from the given string
  strMonth:= Copy(aDateTime, 1, Pos(' ', aDateTime) - 1);
  Delete(aDateTime, 1, Pos(' ', aDateTime));
  iMonth:= MonthNumber(strMonth);

  //Decode the day from the given string
  strDay:= Copy(aDateTime, 1, Pos(' ', aDateTime) - 1);
  Delete(aDateTime, 1, Pos(' ', aDateTime));
  iDay:= StrToIntDef(strDay, 30);

  //Decode the year from the given string
  strYear:= Copy(aDateTime, 1, Pos(' ', aDateTime) -1);
  Delete(aDateTime, 1, Pos(' ', aDateTime));
  iYear:= StrToIntDef(strYear, 1899);

  //Decode the time value from the given string
  strTime:= Copy(aDateTime, 1, Pos(' ', aDateTime) -1);

  //Encode the date value and assign it to result
  Result:= EncodeDate(iYear, iMonth, iDay);

  //Encode the time value and add it to result
  if TryStrToTime(strTime, TimePortion) then
    Result:= Result + TimePortion;
end;

function Add12Hours(aDateTime: string): string;
var
  tmpDateTime: TDateTime;
begin
  //Adding 12 hours to the given
  //date time string value
  tmpDateTime:= ParseString(aDateTime);
  tmpDateTime:= IncHour(tmpDateTime, 12);

  //Formatting the output
  Result:= FormatDateTime('mm/dd/yyyy hh:mm AM/PM', tmpDateTime);
end;

begin
  Writeln(Add12Hours('March 7 2009 7:30pm EST'));
  Readln;
end.
