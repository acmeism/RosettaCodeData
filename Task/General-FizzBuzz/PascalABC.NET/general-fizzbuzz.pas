##
for var i:=1 to 20 do
begin
  var s := '';
  if i mod 3 = 0 then
    s += 'Fizz';
  if i mod 5 = 0 then
    s += 'Buzz';
  if i mod 7 = 0 then
    s += 'Baxx';
  if s = '' then
    Println(i)
  else Println(s);
end
