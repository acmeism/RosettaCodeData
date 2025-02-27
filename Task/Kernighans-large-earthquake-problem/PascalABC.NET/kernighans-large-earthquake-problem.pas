##
foreach var s in ReadLines('data.txt') do
  if StrToFloat(s.ToWords(' ')[2]) > 6 then
    s.Println;
