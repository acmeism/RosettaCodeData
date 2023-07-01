{ the result array must be at least as large as the original array }
procedure reverse(s: array[min .. max: integer] of char, var result: array[min1 .. max1: integer] of char);
 var
  i, len: integer;
 begin
  len := max-min+1;
  for i := 0 to len-1 do
   result[min1 + len-1 - i] := s[min + i]
 end;
