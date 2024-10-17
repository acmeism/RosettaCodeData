begin
  var result: string := power(5bi, integer(power(4, power(3, 2)))).tostring;
  result[1:21].Println;
  result[result.Length - 19:].Println;
  result.Length.Println;
end.
