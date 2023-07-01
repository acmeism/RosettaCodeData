def textonym_value:
    gsub("a|b|c|A|B|C"; "2")
  | gsub("d|e|f|D|E|F"; "3")
  | gsub("g|h|i|G|H|I"; "4")
  | gsub("j|k|l|J|K|L"; "5")
  | gsub("m|n|o|M|N|O"; "6")
  | gsub("p|q|r|s|P|Q|R|S"; "7")
  | gsub("t|u|v|T|U|V"; "8")
  | gsub("w|x|y|z|W|X|Y|Z"; "9");

def explore:
  # given an array (or hash), find the maximum length of the items (or values):
  def max_length: [.[] | length] | max;

  # The length of the longest textonym in the dictionary of numericString => array:
  def longest:
    [to_entries[] | select(.value|length > 1) | .key | length] | max;

  # pretty-print a key-value pair:
  def pp: "\(.key) maps to: \(.value|tostring)";

  split("\n")
  | map(select(test("^[a-zA-Z]+$")))  # select the strictly alphabetic strings
  | length as $nwords
  | reduce .[] as $line
    ( {};
      ($line | textonym_value) as $key
      | .[$key] += [$line] )
  | max_length as $max_length
  | longest    as $longest
  | "There are \($nwords) words in the Textonyms/wordlist word list that can be represented by the digit-key mapping.",
    "They require \(length) digit combinations to represent them.",
    "\( [.[] | select(length>1) ] | length ) digit combinations represent Textonyms.",
    "The numbers mapping to the most words map to \($max_length) words:",
     (to_entries[] | select((.value|length) == $max_length) | pp ),
    "The longest Textonyms in the word list have length \($longest):",
     (to_entries[] | select((.key|length) == $longest and (.value|length > 1)) | pp)
;

explore
