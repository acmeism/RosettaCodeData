# Input should be a sorted array of distinct positive integers
# Output is a stream of distinct arrays, each of which is sorted, and each sum of which is $sum
def sorted_combinations($sum):
  if $sum <= 0 or length == 0 or $sum < .[0] then empty
  else  range(0; length ) as $i
        | .[$i] as $x
        | (($sum / $x) | floor) as $maxn
	| range(1; 1 + $maxn) as $n
          | ([range(0; $n) | $x]) as $prefix
          | ($prefix | add // 0 ) as $psum
          | if $psum == $sum then $prefix
            else $prefix + (.[$i+1 :] | sorted_combinations($sum - $psum) )
            end
  end;

def factorial: reduce range(2;.+1) as $i (1; . * $i);

def product_of_factorials:
  reduce .[] as $n (1; . * ($n|factorial));

# count the number of distinct permutations
def count_distinct_permutations:
  def histogram:
    reduce .[] as $i ([]; .[$i] += 1);
  (length|factorial) / (histogram|product_of_factorials);

def number_of_interesting_numbers($total):
  def digits: [2, 3, 5, 7];
  reduce (digits | sorted_combinations($total)) as $pattern (0;
    . + ($pattern|count_distinct_permutations));

number_of_interesting_numbers(13),
number_of_interesting_numbers(199)
