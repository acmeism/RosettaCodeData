begin
  var (a,b) := ReadInteger2('Enter a,b:');
  if a < b then
    Println($'{a} is less then {b}')
  else if a > b then
    Println($'{a} is greater then {b}')
  else Println($'{a} is equal to then {b}')
end.
