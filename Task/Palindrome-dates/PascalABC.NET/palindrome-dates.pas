uses system;

function Reverse(x: integer) := x mod 10 * 10 + x div 10;

function IsValidDate(y, m, d: integer; var date: datetime) :=
  DateTime.TryParse(y.tostring + '-' + m.tostring + '-' + d.tostring, date);

function PalindromicDates(startYear: integer): sequence of datetime;
begin
  var y := startyear;
  repeat
    var m := Reverse(y mod 100);
    var d := Reverse(y div 100);
    var date: datetime;
    if (IsValidDate(y, m, d, date)) then yield date;
    y += 1;
  until false;
end;

begin
  foreach var date in PalindromicDates(2021).Take(15) do
    Writeln(date.ToString('yyyy-MM-dd'));
end.
