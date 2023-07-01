# Output: an array of the words when read around the rim
def read_teacup:
  . as $in
  | [range(0; length) | $in[.:] + $in[:.] ];

# Boolean
def is_teacup_word($dict):
  . as $in
  | all( range(1; length); . as $i | $dict[ $in[$i:] + $in[:$i] ]) ;

# Output: a stream of the eligible teacup words
def teacup_words:
  def same_letters:
     explode
     | .[0] as $first
     | all( .[1:][]; . == $first);

  # Only consider one word in a teacup cycle
  def consider: explode | .[0] == min;

 # Create the dictionary
  reduce (inputs
           | select(length>2 and (same_letters|not))) as $w ( {};
     .[$w]=true )
  | . as $dict
  | keys[]
  | select(consider and is_teacup_word($dict)) ;

# The task:
teacup_words
| read_teacup
