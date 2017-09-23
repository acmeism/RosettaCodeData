# left-right admissibility
def admissible:
  .[0][-1:] == .[1][0:1];

# input:  [word, dictionary_of_available_words_excluding_word]
# output: a (possibly empty) stream of admissible values: [next_word, updated_dictionary],
#         where next_word can follow the given word.
def next:
  .[0] as $word
   | if $word == null then empty
     else .[1] as $dictionary
     | $word[-1:] as $last
     | (($dictionary[$last] // []) | .[]) as $next
     | [ $next, ($dictionary | remove($next)) ]
     end ;

# Produce an array representing a thread starting at "word":
# Input: [word, dictionary_of_available_words]
def thread:
  if .[1] == [] then [ .[0] ]
  else (next // null) as $next
  | [.[0]] + (if $next then ($next | thread) else [] end)
  end ;

# Input: list of words
# Output: [ maximal_length, maximal_thread]
def maximal:
  def maximum(start):
    . as $dictionary
    | reduce ( [start, ($dictionary | remove(start))] | thread ) as $thread
        ([0, null];
         ($thread|length) as $l
         | if $l > .[0] then [$l, $thread] else . end );

  dictionary as $dictionary
  | reduce .[] as $name
      ( [0,null];
        ($dictionary | maximum($name)) as $ans
	# If your jq does not include "debug", simply remove or comment-out the following line:
	| ([$name, $ans[0]] | debug) as $debug
        | if $ans[0] > .[0] then $ans else . end );
