function isMersennePrime(p: integer): boolean;
begin
  if (p mod 2 = 0) then result := p = 2
  else begin
    for var i := 3 to p.Sqrt.Floor step 2 do
      if (p mod i = 0) then
      begin
        result := false; //not prime
        exit
      end;
    var m_p := Power(2bi, p) - 1bi;
    var s := 4bi;
    for var i := 3 to p do
      s := (s * s - 2bi) mod m_p;
    result := s = 0bi;
  end;
end;

function GetMersennePrimeNumbers(upTo: integer): sequence of integer;
begin
  var response := new List<integer>;
  {$omp parallel for}
  for var i := 2 to upTo do
    if isMersennePrime(i) then response.Add(i);
  response.Sort;
  result := response;
end;

begin
  foreach var mp in GetMersennePrimeNumbers(11213) do
    Write('M', mp, ' ');
  println(#10, milliseconds / 1000, 's');
end.
