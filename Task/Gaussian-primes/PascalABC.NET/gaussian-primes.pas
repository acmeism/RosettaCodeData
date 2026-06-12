uses GraphWPF;

type
  intComplex = record re, im: integer;
  end;

function IsPrime(x: longword): boolean;
begin
  var i := 2;
  while (i * i <= x) and (x mod i <> 0) do
    i += 1;
  Result := i * i > x;
end;

function norm(c: intComplex) := c.re * c.re + c.im * c.im;

function isGaussianPrime(c: intComplex): boolean;
begin
  if c.re = 0 then
  begin
    var x := abs(c.im);
    result := isPrime(x) and ((x - 3) mod 4 = 0);
    exit
  end;
  if c.im = 0 then
  begin
    var x := abs(c.re);
    result := isPrime(x) and ((x - 3) mod 4 = 0);
    exit
  end;
  result := isPrime(norm(c));
end;

function gaussianPrimes(maxNorm: longword): list<intComplex>;
begin
  var gpList := new List<intComplex>;
  var m := Sqrt(maxNorm).Floor;
  var c: intComplex;
  foreach var x in (-m..m) do
    foreach var y in (-m..m) do
    begin
      (c.re, c.im) := (x, y);
      if (norm(c) < maxNorm) and isGaussianPrime(c) then
        gpList.Add(c);
    end;
  result := gpList;
end;

begin
  println('Gaussian primes with a norm less than 100:');
  foreach var gp in gaussianPrimes(10 * 10) index i do
  begin
    write(gp.re:2, if gp.im >= 0 then '+' else '', gp.im, 'i');
    if i mod 10 = 9 then println else print(' ');
  end;

  foreach var gp in gaussianPrimes(50 * 50) do
    fillcircle(gp.re * 4 + 400, gp.im * 4 + 300, 2, colors.Black);
end.
