const weights = [1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1];
const symbols = ["M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I"];

function toRoman(n : Integer) : String;
var
   i, w : Integer;
begin
   for i := 0 to weights.High do begin
      w := weights[i];
      while n >= w do begin
         Result += symbols[i];
         n -= w;
      end;
      if n = 0 then Break;
   end;
end;

PrintLn(toRoman(455));
PrintLn(toRoman(3456));
PrintLn(toRoman(2488));
