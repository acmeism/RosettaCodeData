procedure IsXmasSunday(fromyear, toyear: integer);
var
i: integer;
TestDate: TDateTime;
outputyears: string;
begin
outputyears := '';
  for i:= fromyear to toyear do
  begin
    TestDate := EncodeDate(i,12,25);
    if dayofweek(TestDate) = 1 then
    begin
      outputyears := outputyears + inttostr(i) + ' ';
    end;
  end;
  //CONSOLE
  //writeln(outputyears);
  //GUI
  form1.label1.caption := outputyears;
end;
