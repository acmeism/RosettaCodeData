const TestData: array [0..2] of integer = (7259,86400,6000000);

function SecondsToFormatDate(Sec: integer): string;
var DT: TDateTime;
var Weeks: integer;
var AYear, AMonth, ADay, AHour, AMinute, ASecond, AMilliSecond: Word;
const SecPerDay = 60 * 60 * 24;
begin
{Convert seconds to Delphi TDateTime}
{which is floating point days}
DT:=Sec / SecPerDay;
{Get weeks and subtract them off}
Weeks:=Trunc(DT/7);
DT:=DT - Weeks * 7;
{Decode date}
DecodeDateTime(DT,AYear, AMonth, ADay, AHour, AMinute, ASecond, AMilliSecond);
{Compensate because TDateTime starts on Dec 30th 1899}
if aDay<30 then aDay:=aDay + 1 else aDay:=aDay - 30;
Result:='';
if Weeks<>0 then Result:=Result+IntToStr(Weeks)+' wk, ';
if ADay<>0 then Result:=Result+IntToStr(ADay)+' d, ';
if AHour<>0 then Result:=Result+IntToStr(AHour)+' hr, ';
if AMinute<>0 then Result:=Result+IntToStr(AMinute)+' min, ';
if ASecond<>0 then Result:=Result+IntToStr(ASecond)+' sec, ';
end;

procedure ShowFormatedDataTime(Memo: TMemo);
var I: integer;
begin
for I:=0 to High(TestData) do
Memo.Lines.Add(IntToStr(TestData[I])+' = '+SecondsToFormatDate(TestData[I]));
end;
