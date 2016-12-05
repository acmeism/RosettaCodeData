# Occurrences of .[0] in "operator" will refer to an element in self,
# and occurrences of .[1] will refer to the corresponding element in other.
def elementwise( operator; other ):
  length as $rows
  | if $rows == 0 then .
    else . as $self
    | other as $other
    | ($self[0]|length) as $cols
    | reduce range(0; $rows) as $i
        ([]; reduce range(0; $cols) as $j
          (.; .[$i][$j] = ([$self[$i][$j], $other[$i][$j]] | operator) ) )
    end ;
