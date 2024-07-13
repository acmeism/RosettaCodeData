var anums := |1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1|;
var rnums := 'M CM D CD C XC L XL X IX V IV I'.split;

function ToRoman(x: integer): string;
begin
  Result := '';
  foreach var (a,r) in anums.Zip(rnums) do
  begin
    var n := x div a;
    x := x mod a;
    Result += r * n;
  end;
end;

begin
  var test := |1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 25, 30, 40,
          50, 60, 69, 70, 80, 90, 99, 100, 200, 300, 400, 500, 600, 666, 700, 800, 900, 1000,
          1009, 1444, 1666, 1945, 1997, 1999, 2000, 2008, 2010, 2011, 2500, 3000, 3999|;
  foreach var x in test do
    Println($'{x} - {ToRoman(x)}')
end.
