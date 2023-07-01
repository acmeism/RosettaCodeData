# Given an array of [ doc, array_of_distinct_words ]
# construct a lookup table: { word: array_of_docs }
def inverted_index:
  reduce .[] as $pair
    ({};
     $pair[0] as $doc
     | reduce $pair[1][] as $word
       (.; .[$word] += [$doc]));

def search(words):
  def overlap(that): . as $this
  | reduce that[] as $item ([]; if $this|index($item) then . + [$item] else . end);

  . as $dict
  | if (words|length) == 0 then []
    else reduce words[1:][] as $word
      ( $dict[words[0]]; overlap( $dict[$word] ) )
    end ;
