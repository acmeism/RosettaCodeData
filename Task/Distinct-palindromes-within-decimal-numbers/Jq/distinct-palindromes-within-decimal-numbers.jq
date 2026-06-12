# input: an integer
# output a stream of distinct integers, each representing an admissible palindrome

def palindromes:
  # input: an array
  def is_palindrome: . == reverse;
  def all_palindromes:
    (tostring|explode)
    | range(0; length) as $i
    | range($i+1; length+1) as $j
    | .[$i:$j] # candidate
    | select(is_palindrome)
    | implode
    # trim leading 0s:
    | if length > 1 then sub("^00*"; "") else . end
    | select(length>0) ;

  INDEX(all_palindromes; .) | keys_unsorted[] | tonumber;

def task1:
  " i   palindromes",
   (range(100; 126)
    | "\(.)  \([palindromes]|join(" "))" );

def task2:
 (9, 169, 12769, 1238769, 123498769, 12346098769, 1234572098769,
 123456832098769, 12345679432098769, 1234567905432098769, 123456790165432098769,
 83071934127905179083, 1320267947849490361205695)
 | select( any(palindromes; . > 99) );

task1,
"\nThe integers amongst those in the problem statement that have 2 or more digits:",
task2
