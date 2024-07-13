function IsOddRemainder(x: integer) := x mod 2 <> 0;

function IsEvenRemainder(x: integer) := x mod 2 = 0;

function IsOddBitwise(x: integer) := x and 1 = 1;

function IsEvenBitwise(x: integer) := x and 1 = 0;

begin
  var x := 3;
  Println(x.IsEven,x.IsOdd); // Standard Predicates
  Println(IsEvenRemainder(x),IsOddRemainder(x));
  Println(IsEvenBitwise(x),IsOddBitwise(x));
end.
