# Given any array, produce an array of [item, count] pairs for each run.
def runs:
  reduce .[] as $item
    ( [];
      if . == [] then [ [ $item, 1] ]
      else  .[length-1] as $last
            | if $last[0] == $item
              then (.[0:length-1] + [ [$item, $last[1] + 1] ] )
              else . + [[$item, 1]]
              end
      end ) ;

# string to string
def next_self_referential:
  def runs2integer: # input is an array as produced by runs,
    # i.e. an array of [count, n] pairs, where count is an int,
    # and n is an "exploded" digit
    reduce .[] as $pair
      (""; . + ($pair[1] | tostring) + ([$pair[0]]|implode) ) ;

  explode | sort | reverse | runs | runs2integer;

# Given an integer as a string,
# compute the entire sequence (of strings) to convergence:
def sequence_of_self_referentials:
  def seq:
     . as $ary
     | (.[length-1] | next_self_referential) as $next
     | if ($ary|index($next)) then $ary
       else $ary + [$next] | seq
       end;
  [.] | seq;

def maximals(n):
  def interesting:
    tostring | (. == (explode | sort | reverse | implode));

  reduce range(0;n) as $i
    ([[], 0];  # maximalseeds, length
      if ($i | interesting) then
        ($i|tostring|sequence_of_self_referentials|length) as $length
        | if .[1] == $length then [ .[0] + [$i], $length]
          elif .[1] < $length then [ [$i], $length]
          else .
          end
      else .
      end );

def task(n):
  maximals(n) as $answer
  | "The maximal length to convergence for seeds up to \(n) is \($answer[1]).",
    "The corresponding seeds are the allowed permutations",
    "of the representative number(s): \($answer[0][])",
    "For each representative seed, the self-referential sequence is as follows:",
    ($answer[0][] | tostring
     | ("Representative: \(.)",
        "Self-referential sequence:",
	(sequence_of_self_referentials | map(tonumber))))
    ;

task(1000000)
