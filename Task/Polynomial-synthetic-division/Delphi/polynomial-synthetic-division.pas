program Polynomial_synthetic_division;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  Velthuis.BigRationals;

type
  TPollynomy = record
  public
    Terms: TArray<BigRational>;
    class operator Divide(a, b: TPollynomy): TArray<TPollynomy>;
    constructor Create(Terms: TArray<BigRational>);
    function ToString: string;
  end;

{ TPollynomy }

constructor TPollynomy.Create(Terms: TArray<BigRational>);
begin
  self.Terms := copy(Terms, 0, length(Terms));
end;

class operator TPollynomy.Divide(a, b: TPollynomy): TArray<TPollynomy>;
var
  q, r: TPollynomy;
begin
  var o: TArray<BigRational>;
  SetLength(o, length(a.Terms));
  for var i := 0 to High(a.Terms) do
    o[i] := BigRational.Create(a.Terms[i]);

  for var i := 0 to length(a.Terms) - length(b.Terms) do
  begin
    o[i] := BigRational.Create(o[i] div b.Terms[0]);
    var coef := BigRational.Create(o[i]);
    if coef.Sign <> 0 then
    begin
      var aa: BigRational := 0;
      for var j := 1 to High(b.Terms) do
      begin
        aa := (-b.Terms[j]) * coef;
        o[i + j] := o[i + j] + aa;
      end;
    end;
  end;
  var separator := length(o) - (length(b.Terms) - 1);

  q := TPollynomy.Create(copy(o, 0, separator));
  r := TPollynomy.Create(copy(o, separator, length(o)));

  result := [q, r];
end;

function TPollynomy.ToString: string;
begin
  Result := '[';
  for var e in Terms do
    Result := Result + e.ToString + ' ';
  Result := Result + ']';
end;

var
  p1, p2: TPollynomy;

begin
  p1 := TPollynomy.Create([BigRational.Create(1, 1), BigRational.Create(-12, 1),
    BigRational.Create(0, 1), BigRational.Create(-42, 1)]);

  p2 := TPollynomy.Create([BigRational.Create(1, 1), BigRational.Create(-3, 1)]);

  write(p1.ToString, ' / ', p2.ToString, ' = ');

  var result := p1 / p2;
  writeln(result[0].ToString, ' remainder ', result[1].ToString);
  readln;
end.
