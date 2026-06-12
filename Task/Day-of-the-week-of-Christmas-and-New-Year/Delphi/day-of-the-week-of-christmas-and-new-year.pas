procedure DoChristmasNewYear(Memo: TMemo);
var D: TDate;
begin
D:=EncodeDate(2021,12,25);
Memo.Lines.Add(FormatDateTime('"Christmas Day, 2021 is on: " dddd ', D));
D:=EncodeDate(2022,1,1);
Memo.Lines.Add(FormatDateTime('"New Years Day, 2022 is on: " dddd ', D));
end;

