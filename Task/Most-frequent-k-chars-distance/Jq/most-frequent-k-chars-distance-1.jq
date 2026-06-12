# bag of words
def bow(stream):
  reduce stream as $word ({}; .[($word|tostring)] += 1);

# Like sort_by(f) but for items that compare equal, retain the original order
def sort_by_decreasing(f):
  # Add $n-$i
  def enumerate: . as $in | length as $n | reduce range(0;$n) as $i ([]; . + [ [$n-$i, $in[$i] ] ]);
  enumerate
  | sort_by((.[1]|f), .[0])
  | reverse
  | map(.[1]);
