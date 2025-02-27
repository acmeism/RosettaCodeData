##
uses System;

var year := ReadlnInteger('Enter year:');
var date := new DateTime(year, 12, 31);

var lastfridays :=
     (0..360)
     .Select(x -> date.AddDays(-x))
     .where(x -> x.DayOfWeek = DayOfWeek.friday)
     .GroupBy(x -> x.Month)
     .Select(g -> g.First)
     .Reverse;

foreach var d in lastfridays do
  writeln(d.Year, '-', d.Month, '-', d.Day);
