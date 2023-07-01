# This workhorse function assumes its arguments are
# non-negative integers represented as decimal strings:
def add(num1;num2):
  if (num1|length) < (num2|length) then add(num2;num1)
  else  (num1 | explode | map(.-48) | reverse) as $a1
  | (num2 | explode | map(.-48) | reverse) as $a2
  | reduce range(0; num1|length) as $ix
      ($a2;  # result
       ( $a1[$ix] + .[$ix] ) as $r
         | if $r > 9 # carrying
           then
             .[$ix + 1] = ($r / 10 | floor) +  (if $ix + 1 >= length then 0 else .[$ix + 1] end )
             | .[$ix] = $r - ( $r / 10 | floor ) * 10
           else
             .[$ix] = $r
           end )
  | reverse | map(.+48) | implode
  end ;

# Input: an array
def is_palindrome:
  . as $in
  | (length -1) as $n
  | all( range(0; length/2); $in[.] == $in[$n - .]);

# Input: a string representing a decimal number.
# Output: a stream of such strings generated in accordance with the Lychrel rule,
# subject to the limitation imposed by "limit", and ending in true if the previous item in the stream is a palindrome
def next_palindromes(limit):
   def toa: explode | map(.-48);
   def tos: map(.+48) | implode;
   def myadd(x;y): add(x|tos; y|tos) | toa;
   # input: [limit, n]
   def next:
     .[0] as $limit
     | .[1] as $n
     | if $limit <= 0 then empty
       else  myadd($n ; $n|reverse) as $sum
	| ($sum,
         if ($sum | is_palindrome) then true else [$limit - 1, $sum] | next end)
       end;
  [limit, toa] | next | if type == "boolean" then . else tos end;

# Consider integers in range(0;n) using maxiter as the maximum number
# of iterations in the search for palindromes.
# Emit a dictionary:
# { seed: _, palindromic_seed: _, related: _} + {($n): $n} for all related $n
# where .seed is an array of integers holding the potential Lychrel seeds, etc
def lychrel_dictionary(n; maxiter):
    reduce range(0; n) as $i ({};
        ($i | tostring) as $is
	| if .[$is] then .related += [$i]
	  else [$is | next_palindromes(maxiter)] as $seq
	  | . as $dict
          # | ([$i, $seq] | debug) as $debug
          | if $seq[-1] == true then .
	    else if ($is | explode | is_palindrome) then .palindromic_seed += [$i] else . end
            | if any($seq[]; $dict[.]) then .related += [$i]
              else .seed += [$i]
              end
            | reduce $seq[] as $n (.; if .[$n] then . else .[$n] = $n end)
            end
          end ) ;
