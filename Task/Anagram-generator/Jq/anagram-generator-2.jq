# Input: a string
def profile: bow( explode[] | [.] | implode);

# Comparison of profiles
# . and $p2 should be profiles
def le($p2):
  . as $p1
  | all( keys_unsorted[]; $p1[.] <= $p2[.]);

def eq($p2):
  . as $p1
  | all( keys_unsorted + ($p2|keys_unsorted) | unique[]; $p1[.] == $p2[.]);

# Construct a list of relevant words using the given stream.
# $min is the a-priori minimum word length and
# so if $min is the length of $word, we are looking for exact anagrams:
def dict(stream; $word; $min):
  ($word|length) as $length
  | ($word|profile) as $profile
  | if $length == $min
    then [stream | select(profile|eq($profile))]
    else [stream
          | select(length >= $min and
               length <= $length and
               (profile|le($profile)))]
    end ;

# Input: an array of admissible words.
# Output: a stream of anagrams of $word
def anagram($word):
  ($word|profile) as $profile
  | .[]
  | select(profile|eq($profile));

# Input: an array of admissible words.
# Output: a stream of subanagrams of $word
# regarding each occurrence of a letter as distinct from all others
def subanagrams($word):
  ($word|profile) as $profile
  | .[]
  | select(profile|le($profile));

# input: an array to be extended with an additional dictionary word.
# output: a stream of arrays with additional words
# selected from the characters in the string $letters.
# The input array should be in alphabetical order; if it is,
# so will the output array.
def extend($letters; $dict):
  if $letters == "" then .
  else . as $in
  | ($dict|subanagrams($letters)) as $w
  | select(if ($in|length) > 0 then $in[-1] <= $w else true end)
  | ($letters | minus($w)) as $remaining
  | ($in + [$w]) | extend($remaining; $dict)
  end;

def anagram_phrases($letters):
  . as $dict
  | once([] | extend($letters; $dict));

# Global: $anagram $word $min
def main:
  if $anagram
  then dict(inputs; $word; $word|length)[]
  else  dict(inputs; $word; $min)
  | anagram_phrases($word)
  end ;

main
