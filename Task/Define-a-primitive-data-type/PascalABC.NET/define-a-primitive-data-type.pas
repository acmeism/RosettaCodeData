type RangeInt = record
  n: integer;
public
  constructor(nn: integer);
  begin
    if nn not in 1..10 then
      raise new System.ArgumentOutOfRangeException;
    n := nn;
  end;
  function ToString: string; override := n.ToString;
  static function operator implicit (n: integer): RangeInt := new RangeInt(n);
  static function operator+(a,b: RangeInt): RangeInt := a.n + b.n;
  static function operator-(a,b: RangeInt): RangeInt := a.n - b.n;
  static function operator*(a,b: RangeInt): RangeInt := a.n * b.n;
  static function operator/(a,b: RangeInt): real := a.n / b.n;
  static function operator div(a,b: RangeInt): RangeInt := a.n div b.n;
  static function operator mod(a,b: RangeInt): RangeInt := a.n mod b.n;
end;

function RInt(n: integer) := new RangeInt(n);

begin
  var a: RangeInt := 7;
  var b: RangeInt := 3;
  Print(a + b, a - b, a div b, a mod b);
  Print(a * b); // ArgumentOutOfRangeException exception
end.
