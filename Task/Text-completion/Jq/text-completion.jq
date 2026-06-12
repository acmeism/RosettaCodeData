include "levenshtein-distance" {search: "."};  # https://rosettacode.org/wiki/Levenshtein_distance#jq

# input: a dictionary
# output an array of {word, d, p} objects showing the best matches as measured
# by the Levenshtein distance, d; p is an indicator of similarity expressed as
# 100 * (max(0, ($word|length) - d) / ($word|length) ) rounded to the nearest integer
def closest($word):
  if .[$word] then {$word, d:0, percentage: 100}
  else
  "Levenshtein-closest words to \($word):",
  (($word|length) as $length
   | (keys_unsorted | map(select(length | (. > $length-3) and (. < $length + 3)))) as $candidates
   | $candidates
   | (length|debug) as $debug
   | map( {word: ., d: levenshteinDistance($word; .)} )
   | minima(.d)
   | map( .p = (100 * ([0, ($length - .d) ] | max / $length) | round )))
  end ;

# Input: a dictionary
# Output: an array of possible completions of $word
def completion($word):
  "Possible completions of \($word):",
    (keys_unsorted | map(select(startswith(word))));

def task:
  INDEX(inputs; .)  # the dictionary
  | completion("compli"),
    closest("complition"),
    closest("compxxxxtion")
;

task
