const Sunday = System.DayOfWeek.Sunday;

begin
  (2008..2121).Where(y -> DateTime.Create(y,12,25).DayOfWeek = Sunday).Println
end.
