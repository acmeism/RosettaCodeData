const
  alphabet = 'abcdefghijklmnopqrstuvwxyz';

function ispangram(text: string) := alphabet.All(c -> text.Contains(c));

begin
  ispangram('The quick brown fox jumps over the lazy dog').Println;
end.
