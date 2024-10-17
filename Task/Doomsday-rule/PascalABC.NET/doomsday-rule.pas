const
  days: array of string = ('Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday');
  dooms: array of array of integer = ((3, 7, 7, 4, 2, 6, 4, 1, 5, 3, 7, 5),
                                      (4, 1, 7, 4, 2, 6, 4, 1, 5, 3, 7, 5));

function isleap(year: integer) := (year mod 4 = 0) and ((year mod 100 <> 0) or (year mod 400 = 0));

function weekday(year, month, day: integer): string;
begin
  var c := year div 100;
  var r := year mod 100;
  var s := r div 12;
  var t := r mod 12;
  var c_anchor := (5 * (c mod 4) + 2) mod 7;
  var doomsday := (s + t + (t div 4) + c_anchor) mod 7;
  var anchorday := dooms[if isleap(year) then 1 else 0][month - 1];
  var weekday := (doomsday + day - anchorday + 7) mod 7;
  result := days[weekday];
end;

begin
  var dates := |(1800, 1, 6), (1875, 3, 29), (1915, 12, 7), (1970, 12, 23),
                (2043, 5, 14), (2077, 2, 12), (2101, 4, 2)|;
  foreach var d in dates do
    writeln(d[0], '-', d[1]:2, '-', d[2]:2, ' -> ', weekday(d[0], d[1], d[2]));
end.
