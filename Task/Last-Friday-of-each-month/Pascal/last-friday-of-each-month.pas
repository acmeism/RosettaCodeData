program LastFriday;

{$mode objfpc}{$H+}

uses
   SysUtils;

type
  weekdays = (Sun,Mon,Tue,Wed,Thu,Fri,Sat);

var
   m, d, y : integer;

function IsLeapYear(Year : integer) : boolean;
begin
    if Year mod 4 <> 0  { quick exit in most likely case }
        then IsLeapYear := false
    else if Year mod 400 = 0
        then IsLeapYear := true
    else if Year mod 100 = 0
        then IsLeapYear := false
    else { non-century year and divisible by 4 }
        IsLeapYear := true;
end;


function DaysInMonth(Month, Year : integer) : integer;
const
    LastDay : array[1..12] of integer =
        (31,28,31,30,31,30,31,31,30,31,30,31);
begin
    if (Month = 2) and (IsLeapYear(Year)) then
        DaysInMonth := 29
    else
        DaysInMonth := LastDay[Month];
end;

{ return day of week (Sun = 0, Mon = 1, etc.) for a }
{ given mo, da, and yr using Zeller's congruence    }
function DayOfWeek(mo, da, yr : integer) : weekdays;
var
    y, c, z : integer;
begin
    if mo < 3 then
        begin
            mo := mo + 10;
            yr := yr - 1
        end
    else mo := mo - 2;
    y := yr mod 100;
    c := yr div 100;
    z := (26 * mo - 2) div 10;
    z := z + da + y + (y div 4) + (c div 4) - 2 * c + 777;
    DayOfWeek := weekdays(z mod 7);
end;

{ return the calendar day of the last occurrence of the }
{ specified weekday in the given month and year         }
function LastWeekday(k : weekdays; m, y : integer) : integer;
var
  d : integer;
  w : weekdays;
begin
  { determine weekday for the last day of the month }
  d := DaysInMonth(m, y);
  w := DayOfWeek(m, d, y);
  { back up as needed to desired weekday }
  if w >= k then
    LastWeekday := d - (ord(w) - ord(k))
  else
    LastWeekday := d - (7 - ord(k)) - ord(w);
end;


begin { main program }
  write('Find last Fridays in what year? ');
  readln(y);
  writeln;
  writeln('Month  Last Fri');
  for m := 1 to 12 do
    begin
      d  := LastWeekday(Fri, m, y);
      writeln(m:5,'   ',d:5);
    end;
end.
