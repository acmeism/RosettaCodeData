# "bag of words"
def bow(stream):
  reduce stream as $word ({}; .[($word|tostring)] += 1);

# Given an array of values as input, generate a stream of values of the maximal elements as determined by f.
# Notes:
# 1. If the input is [] then the output stream is empty.
# 2. If f evaluates to null for all the input elements, then the output stream will be the stream of all the input items.
def maximal_by(f):
  (map(f) | max) as $mx
  | .[] | select(f == $mx);

def consonants: gsub("[aeiou]";"");

def letters_are_distinct:
  bow(explode[])
  | all(.[]; . == 1);
