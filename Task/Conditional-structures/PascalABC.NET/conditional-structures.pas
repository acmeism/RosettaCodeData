// if statement
if condition then
  operator;

if condition then
  operator
else operator;

if condition then
  operator
else if condition then
  operator
else operator;

// case statement
case Month of
  3..5: Print('Spring');
  6..8: Print('Summer');
  9..11: Print('Autumn');
  12,1,2: Print('Winter');
  else throw ArgumentException('Bad Month')
end;

// ternary operator
var min := if a < b then a else b;

// ternary operator in C style
var min := a < b ? a : b;
