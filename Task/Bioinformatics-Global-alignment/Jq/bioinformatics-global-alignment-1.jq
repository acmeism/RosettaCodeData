### Generic helper functions

# bag-of-words
def bow(stream):
  reduce stream as $word ({}; .[($word|tostring)] += 1);

def permutations:
  if length == 0 then []
  else
    range(0;length) as $i
    | [.[$i]] + (del(.[$i])|permutations)
  end ;
