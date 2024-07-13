{$zerobasedstrings}

var key := ']kYV}(!7P$n5_0i R:?jOWtF/=-pe''AD&@r6%ZXs"v*N[#wSl9zq2^+g;LoB`aGh{3.HIu4fbK)mU8|dMET><,Qc\C1yxJ';

function Encode(s: string): string := s.Select(c -> key[c.code - 32]).JoinToString;

function Decode(s: string): string := s.Select(c -> Char(key.IndexOf(c) + 32)).JoinToString;

begin
  var s := 'The quick brown fox jumps over the lazy dog, who barks VERY loudly!';
  var enc := Encode(s);
  Println('Encoded:  ' + enc);
  Println('Decoded:  ' + Decode(enc))
end.
