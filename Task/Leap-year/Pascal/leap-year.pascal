program LeapYear;
uses
  sysutils;//includes isLeapYear

procedure TestYear(y: word);
begin
  if IsLeapYear(y) then
    writeln(y,' is a leap year')
  else
    writeln(y,' is NO leap year');
end;
Begin
  TestYear(1900);
  TestYear(2000);
  TestYear(2100);
  TestYear(1904);
end.
