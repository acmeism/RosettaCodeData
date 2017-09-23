(* Taken from the 'Ada 99' project, https://marquisdegeek.com/code_ada99 *)

program BernoulliForAda99;


type
  Fraction = object
  private
    numerator, denominator: Int64;

  public
    procedure assign(n, d: Int64);
    procedure subtract(rhs: Fraction);
    procedure multiply(value: Int64);
    procedure reduce();
    procedure writeOutput();
end;


function gcd(a, b: Int64):Int64;
begin
  if (b = 0) then
    gcd := a
  else
    gcd := gcd(b, a mod b)
end;


procedure Fraction.writeOutput();
begin
  write(numerator);
  if (numerator <> 0) then
  begin
    write('/');
    write(denominator);
  end;
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
begin
  numerator := numerator * value;
end;


procedure Fraction.reduce();
var gcdResult: Int64;
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
    setlength(results, n);

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

  for b:= 1 to 25 do
    begin
      write(b);
      write(' : ');
      result := calculateBernoulli(b);
      result.writeOutput();
      writeln;
  end;

end.
