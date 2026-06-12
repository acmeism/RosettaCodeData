def Bacon:
    {
            "a" : "AAAAA", "b" : "AAAAB", "c" : "AAABA", "d" : "AAABB", "e" : "AABAA",
            "f" : "AABAB", "g" : "AABBA", "h" : "AABBB", "i" : "ABAAA", "j" : "ABAAB",
            "k" : "ABABA", "l" : "ABABB", "m" : "ABBAA", "n" : "ABBAB", "o" : "ABBBA",
            "p" : "ABBBB", "q" : "BAAAA", "r" : "BAAAB", "s" : "BAABA", "t" : "BAABB",
            "u" : "BABAA", "v" : "BABAB", "w" : "BABBA", "x" : "BABBB", "y" : "BBAAA",
            "z" : "BBAAB", " " : "BBBAA"  # use " " to denote any non-letter
     };

def encode($plaintext; $message):
  (reduce ($plaintext|ascii_downcase|chars) as $c ("";
     if $c|ascii_downcase == . then . + Bacon[$c] else . + Bacon[" "] end)) as $et
  # "A"s to be in lower case, "B"s in upper case
  | label $out
  | foreach ($message|ascii_downcase|chars) as $c ( {sb: "", count: 0};
      if ($c | is_lower)
      then .sb = if $et[.count: .count+1] == "A" then .sb + $c else .sb + ($c|ascii_upcase) end
      | .count += 1
      | if .count == ($et|length) then .emit = .sb, break $out else . end
      else .sb += $c
      end;
      select(.emit).emit ) ;

def decode($message):
  Bacon as $Bacon
  | (reduce ($message|chars) as $c ("";
       if   ($c|is_lower) then . + "A"
       elif ($c|is_upper)   then . + "B"
       else .
       end)) as $et
  | reduce range(0; $et|length; 5) as $i ("";
       $et[$i : $i+5] as $quintet
       | . + ($Bacon | key($quintet)) ) ;


{ plainText: "the quick brown fox jumps over the lazy dog",
  message: (
    "bacon's cipher is a method of steganography created by francis bacon." +
    "this task is to implement a program for encryption and decryption of " +
    "plaintext using the simple alphabet of the baconian cipher or some " +
    "other kind of representation of this alphabet (make anything signify anything). " +
    "the baconian alphabet may optionally be extended to encode all lower " +
    "case characters individually and/or adding a few punctuation characters " +
    "such as the space.") }
| .cipherText = encode(.plainText; .message)
| .decodedText = decode(.cipherText)
|  "Cipher text ->\n\n\(.cipherText)",
   "\nHidden text ->\n\n\(.decodedText)"
