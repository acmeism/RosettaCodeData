# Generic "bag of words" utility:
def bow(stream):
  reduce stream as $word ({}; .[($word|tostring)] += 1);

# The ngrams as a bow
def ngrams($n):
  ascii_upcase as $text
  | bow( range(0;$text|1+ length - $n) as $i | $text[$i:$i+$n]);

# The task
# Sort by increasing frequency, then by lexicographical order
def ngrams($text; $n):
  ($text|ngrams($n)) as $ngrams
  | "\nAll \($n)-grams of '\($text)' and their frequencies:",
    ($ngrams|to_entries|sort_by(.value,.key)[] | "\(.key): \(.value)" ) ;

ngrams("Live and let live"; 2,3,4)
