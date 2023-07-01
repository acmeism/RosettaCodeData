type
  days = (Mon, Tue, Wed, Thu, Fri, Sat, Sun);
var
  workDays, week, weekendDays: set of days;
begin
  workdays := [Mon, Tue, Wed, Thu, Fri];
  week := workdays + [Sat, Sun];
  weekendDays := week - workdays;
end;
