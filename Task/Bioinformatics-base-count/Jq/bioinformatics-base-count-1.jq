def lpad($len; $fill): tostring | ($len - length) as $l | ($fill * $l)[:$l] + .;

# Create a bag of words, i.e. a JSON object with counts of the items in the stream
def bow(stream):
  reduce stream as $word ({}; .[($word|tostring)] += 1);
