program atoz;
type
  tlowAlphabet = 'a'..'z';
var
  ch : tlowAlphabet;

begin
  for ch := low(ch) to High(ch) do
    write(ch);
  writeln;
end.
