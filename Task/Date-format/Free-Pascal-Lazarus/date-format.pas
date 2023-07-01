program Format_Date_Time;
uses
  SysUtils;
begin
  WriteLn(FormatDateTime('yyyy-mm-dd', Now) +#13#10+ FormatDateTime('dddd, mmmm dd, yyyy', Now));
end.
