def reverse_string: explode | reverse | implode;

"rosetta code phrase reversal"
| split(" ") as $words
| "0. input:               \(.)",
  "1. string reversed:     \(reverse_string)",
  "2. each word reversed:  \($words | map(reverse_string) | join(" "))",
  "3. word-order reversed: \($words | reverse | join(" "))"
