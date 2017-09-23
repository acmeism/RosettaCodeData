def is_sorted:
  if length <= 1 then true
  else .[0] <= .[1] and (.[1:] | is_sorted)
  end;

def longest_ordered_words:
  # avoid string manipulation:
  def is_ordered: explode | is_sorted;
  map(select(is_ordered))
  | (map(length)|max) as $max
  | map( select(length == $max) );


split("\n")  | longest_ordered_words
