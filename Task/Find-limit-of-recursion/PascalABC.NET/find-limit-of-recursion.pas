procedure Recur(i: integer);
begin
  System.Console.WriteLine(i);
  Recur(i + 1);
end;

begin
  Recur(0);
end.
