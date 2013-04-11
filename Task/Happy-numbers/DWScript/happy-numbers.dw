function IsHappy(n : Integer) : Boolean;
var
   cache : array of Integer;
   sum : Integer;
begin
   while True do begin
      sum := 0;
      while n>0 do begin
         sum += Sqr(n mod 10);
         n := n div 10;
      end;
      if sum = 1 then
         Exit(True);
      if sum in cache then
         Exit(False);
      n := sum;
      cache.Add(sum);
   end;
end;

var n := 8;
var i : Integer;

while n>0 do begin
   Inc(i);
   if IsHappy(i) then begin
      PrintLn(i);
      Dec(n);
   end;
end;
