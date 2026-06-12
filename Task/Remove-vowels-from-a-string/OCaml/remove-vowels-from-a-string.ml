let remove_vowels s : string =
  let not_vowel = Fun.negate (String.contains "AaEeIiOoUu") in
  String.to_seq s |> Seq.filter not_vowel |> String.of_seq
