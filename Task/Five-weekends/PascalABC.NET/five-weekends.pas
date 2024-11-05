uses system;

const
  startYear = 1900;
  endYear = 2100;

begin
  var query := new List<datetime>;
  foreach var year in (startyear..endyear) do
    foreach var month in (1..12) do
      if DateTime.DaysInMonth(year, month) = 31 then
        query.Add(new DateTime(year, month, 1));
  query := query.where(d -> d.dayofweek = dayofweek.Friday).ToList;

  println('Count:', query.Count);
  println;
  println('First five:');
  foreach var date in query.Take(5) do
    writeln(date.Year, '-', date.Month);
  println;
  Println('Last five:');
  foreach var date in query.Skip(query.Count - 5) do
    writeln(date.Year, '-', date.Month);
  println;
  println('Years without 5 weekends:');
  (startyear..endyear).except(query.Select(d -> d.year)).Println
end.
