##
uses System;

function islongyear(year: integer): boolean;
begin
  var startdate := new DateTime(year, 1, 1);
  var enddate := new DateTime(year, 12, 31);
  result := (startdate.DayOfWeek = DayOfWeek.Thursday) or (enddate.DayOfWeek = DayOfWeek.Thursday)
end;

(2000..2100).Where(y -> islongyear(y)).Println;
