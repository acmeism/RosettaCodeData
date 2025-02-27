type
  Approx = record
  private
    value, sigma: real;
  public
    constructor(v, s: real);
    begin
      value := v;
      sigma := s;
    end;

    class function operator-(a: Approx) := new Approx(-a.value, a.sigma);
    class function operator+(a: Approx) := a;

    class function operator+(a, b: Approx) := new Approx(a.value + b.value, (a.sigma.Sqr + b.sigma.Sqr).Sqrt);
    class function operator+(a: Approx; b: real) := new Approx(a.value + b, a.sigma);
    class function operator+(b: real; a: Approx) := a + b;

    class function operator-(a, b: Approx) := a + (-b);
    class function operator-(a: Approx; b: real) := a + (-b);
    class function operator-(b: real; a: Approx) := (-a) + b;

    class function operator*(a, b: Approx): Approx;
    begin
      var v := a.value * b.value;
      Result := new Approx(v, v * ((a.sigma / a.value).Sqr + (b.sigma / b.value).Sqr).Sqrt)
    end;

    class function operator*(a: Approx; b: real) := new Approx(a.value * b, abs(a.sigma * b));
    class function operator*(b: real; a: Approx) := a * b;

    class function operator/(a, b: Approx): Approx;
    begin
      var v := a.value / b.value;
      Result := new Approx(v, v * ((a.sigma / a.value).Sqr + (b.sigma / b.value).Sqr).Sqrt);
    end;

    class function operator/(a: Approx; b: real) := new Approx(a.value / b, abs(a.sigma * b));
    class function operator/(b: real; a: Approx) := a / b;

    class function operator**(a: Approx; b: real): Approx;
    begin
      var v := power(a.value, b);
      Result := new Approx(v, abs(v * b * a.sigma / a.value));
    end;

    function ToString: string; override;
    begin
      Result := Format('{0} ± {1}', value, sigma);
    end;
  end;

function Sqrt(Self: Approx): Approx; extensionmethod;
begin
  result := Self ** 0.5;
end;

begin
  var x1 := new Approx(100, 1.1);
  var y1 := new Approx(50, 1.2);
  var x2 := new Approx(200, 2.2);
  var y2 := new Approx(100, 2.3);
  println(((x1 - x2) ** 2 + (y1 - y2) ** 2).Sqrt);
end.
