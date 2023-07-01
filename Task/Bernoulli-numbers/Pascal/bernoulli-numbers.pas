(* Taken from the 'Ada 99' project, https://marquisdegeek.com/code_ada99 *)

program BernoulliForAda99;

uses BigDecimalMath; {library for arbitary high precision BCD numbers}

type
  Fraction = object
  private
    numerator, denominator: BigDecimal;

  public
    procedure assign(n, d: Int64);
    procedure subtract(rhs: Fraction);
    procedure multiply(value: Int64);
    procedure reduce();
    procedure writeOutput();
end;


function gcd(a, b: BigDecimal):BigDecimal;
begin
  if (b = 0) then begin
    gcd := a;
    end
  else begin
    gcd := gcd(b, a mod b);
 end;
end;


procedure Fraction.writeOutput();
var sign : char;
begin
  sign := ' ';
  if (numerator<0) then sign := '-';
  if (denominator<0) then sign := '-';
  write(sign + BigDecimalToStr(abs(numerator)):45);
  write(' / ');
  write(BigDecimalToStr(abs(denominator)));
end;


procedure Fraction.assign(n, d: Int64);
begin

  numerator := n;
  denominator := d;
end;


procedure Fraction.subtract(rhs: Fraction);
begin
  numerator := numerator * rhs.denominator;
  numerator := numerator - (rhs.numerator * denominator);
  denominator := denominator * rhs.denominator;
end;


procedure Fraction.multiply(value: Int64);
var
  temp :BigDecimal;
begin
  temp := value;
  numerator := numerator * temp;
end;


procedure Fraction.reduce();
var gcdResult: BigDecimal;
begin
  gcdResult := gcd(numerator, denominator);
  begin
    numerator := numerator div gcdResult;     (* div is Int64 division *)
    denominator := denominator div gcdResult; (* could also use round(d/r) *)
  end;
end;


function calculateBernoulli(n: Int64) : Fraction;
var
  m, j: Int64;
  results: array of Fraction;

  begin
    setlength(results, 60) ; {largest value 60}
    for m:= 0 to n do
    begin
      results[m].assign(1, m+1);

      for j:= m downto 1 do
        begin
          results[j-1].subtract(results[j]);
          results[j-1].multiply(j);
          results[j-1].reduce();
        end;
    end;

    calculateBernoulli := results[0];
end;


(* Main program starts here *)

var
  b: Int64;
  result: Fraction;

begin
  writeln('Calculating Bernoulli numbers...');
  writeln('B( 0) :                                             1 / 1');
  for b:= 1 to 60  do
    begin
	if (b<3) or ((b mod 2) = 0) then begin
          result := calculateBernoulli(b);
          write('B(',b:2,')');
          write(' : ');
          result.writeOutput();
        writeln;
      end;
  end;
end.
