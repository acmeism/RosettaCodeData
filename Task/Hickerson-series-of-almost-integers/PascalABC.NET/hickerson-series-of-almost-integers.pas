##
var ln2: decimal := decimal.Parse('0.693147180559945309417232121458');
var h := decimal(0.5) / ln2;

for var i := 1 to 17 do
begin
  h := h * i / ln2;
  var w := BigInteger(h);
  var d := (h - decimal(w)).ToString.Substring(2, 1);

  Writeln('n: ', i:2, '  h: ', h, '  Nearly integer: ', (d = '0') or (d = '9'));
end;
