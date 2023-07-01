# Ties share what would have been their first ordinal number
def standard_ranking:
  . as $raw
  | ([range(1;length;2) | $raw[.]]) as $scores
  | reduce range(1; $scores|length) as $i
      ([1]; if $scores[$i - 1] == $scores[$i] then . + [.[-1]]
            else . + [$i + 1]
            end) ;

def modified_ranking:
  # The helper function resolves [ranks, tentative]
  # by appending the ranks of the ties to "ranks"
  def resolve:
    (.[1] | length) as $length
    | if $length == 0 then .[0]
      else .[1][-1] as $max
           | .[0] + ( .[1] | map( $max) )
      end ;
  . as $raw
  | ([range(1;length;2) | $raw[.]]) as $scores
  | reduce range(1; $scores|length) as $i
      # state: [ranks, tentative]
      ([ [], [1] ];
       if $scores[$i - 1] == $scores[$i] then [.[0], .[1] + [ $i + 1 ]]
       else [ resolve,  [ $i + 1 ] ]
       end )
  | resolve ;

def dense_ranking: # next available
  . as $raw
  | ([range(1;length;2) | $raw[.]]) as $scores
  | reduce range(1; $scores|length) as $i
      ([1]; if $scores[$i - 1] == $scores[$i] then . + [.[-1]]
            else . + [ .[-1] + 1]
            end );

def ordinal_ranking: # unfair to some!
  [ range(1; 1 + length/2) ] ;

def fractional_ranking:
  # The helper function resolves [ranks, tentative]
  # by appending the averages of the tentative ranks to "ranks"
  def resolve:
    (.[1] | length) as $length
    | if $length == 0 then .[0]
      else (.[1] | add  / $length) as $avg
           | .[0] + ( .[1] | map( $avg) )
      end ;
  . as $raw
  | ([range(1;length;2) | $raw[.]]) as $scores
  | reduce range(1; $scores|length) as $i
      # state: [ranks, tentative]
      ([ [], [1] ];
       if $scores[$i - 1] == $scores[$i] then [.[0], .[1] + [ $i + 1 ]]
       else [ resolve,  [ $i + 1 ] ]
       end )
  | resolve ;
