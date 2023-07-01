def vigenere(text; key; encryptp):
  # retain alphabetic characters only
  def n:
    ascii_upcase | explode | map(select(65 <= . and . <= 90)) | [., length];
   (text | n) as [$xtext, $length]
  | (key | n) as [$xkey, $keylength]
  | reduce range(0; $length) as $i (null;
	($i % $keylength) as $ki
	| . + [if encryptp
	       then (($xtext[$i] + $xkey[$ki] - 130) % 26) + 65
               else (($xtext[$i] - $xkey[$ki] +  26) % 26) + 65
	       end] )
  | implode;

# Input: sample text
def example($key):
  vigenere(.; $key; true)
  | . as $encoded
  | ., vigenere($encoded; $key; false) ;

"Beware the Jabberwock, my son! The jaws that bite, the claws that catch!"
| (., example("VIGENERECIPHER")),
  "",
  (., example("ROSETTACODE"))
