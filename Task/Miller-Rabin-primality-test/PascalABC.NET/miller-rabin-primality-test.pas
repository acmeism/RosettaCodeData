uses System.Security.Cryptography;

function IsProbablePrime(source: biginteger; certainty: integer): boolean;
begin
  if (source = 2) or (source = 3) then
  begin result := true; exit end;

  if (source < 2) or (source mod 2 = 0) then
  begin result := false; exit end;

  var d := source - 1;
  var s := 0;

  while d mod 2 = 0 do
  begin
    d := d div 2;
    s += 1;
  end;

  var rng := RandomNumberGenerator.Create();
  var bytes := new byte[source.ToByteArray.LongLength];
  var a: biginteger;
  loop certainty do
  begin
    repeat
      rng.GetBytes(bytes);
      a := new BigInteger(bytes);
    until (a >= 2) and (a < source - 2);

    var x := BigInteger.ModPow(a, d, source);
    if (x = 1) or (x = source - 1) then continue;

    for var r := 1 to s - 1 do
    begin
      x := BigInteger.ModPow(x, 2, source);
      if x = 1 then
      begin result := false; exit end;
      if x = source - 1 then break;
    end;

    if x <> source - 1 then
    begin result := false; exit end;
  end;

  result := true;
end;

begin
  var data := |'4547337172376300111955330758342147474062293202868155909489',
  '4547337172376300111955330758342147474062293202868155909393'|;

  foreach var candidate in data do
    isprobableprime(candidate.tobiginteger, 10).Println;

  foreach var x in (900..1000) do
    if isprobableprime(x, 10) then print(x);
end.
