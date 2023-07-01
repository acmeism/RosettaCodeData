program sundays;

Uses sysutils;

type
  MonthLength = Array[1..13] of Integer;

procedure sund(y : Integer);
var
  dt : TDateTime;
  m,mm : Integer;
  len : MonthLength;
begin
   len[1] := 31; len[2] := 28; len[3] := 31; len[4] := 30;
   len[5] := 31; len[6] := 30; len[7] := 31; len[8] := 31;
   len[9] := 30; len[10] := 31; len[11] := 30; len[12] := 31; len[13] := 29;
   for m := 1 to 12 do
   begin
      mm := m;
      if (m = 2) and IsLeapYear( y ) then
         mm := 13;
      dt := EncodeDate( y, mm, len[mm] );
      dt := EncodeDate( y, mm, len[mm] - DayOfWeek(dt) + 1 );
      WriteLn(FormatDateTime('YYYY-MM-DD', dt ));
   end;
end;

var
  i : integer;
  yy: integer;
begin
   for i := 1 to paramCount() do begin
      Val( paramStr(1), yy );
      sund( yy );
   end;
end.
