type
  ErrOdd = class (Exception) end;
  ErrLen = class (Exception) end;

function middle_three_digits(i: integer): string;
begin
  var s := abs(i).ToString;
  if s.Length < 3 then raise new ErrLen;
  if s.Length mod 2 = 0 then raise new ErrOdd;
  var mid := s.Length div 2;
  result := s[mid:mid + 3];
end;

begin
  var passing := |123, 12345, 1234567, 987654321, 10001, -10001, -123, -100, 100, -12345|;
  var failing := |1, 2, -1, -10, 2002, -2002, 0|;

  foreach var x in passing + failing do
    try
      var answer := middle_three_digits(x);
      writeln(x:10, ' -> ', answer);
    except
      on ErrOdd do
        writeln(x:10, ' -> must have an odd number of digits');
      on ErrLen do
        writeln(x:10, ' -> must have 3 digits or more');
    end;
end.
