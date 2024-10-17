function entropy(s: string): real;
begin
  result := 0.0;
  foreach var c in s.distinct do
  begin
    var freq := s.count(x -> x = c) / s.length;
    result += -freq * log2(freq);
  end;
end;

begin
  entropy('1223334444').println;
end
