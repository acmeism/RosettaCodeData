# The 1-d cellular automaton:
def next:
   # Conveniently, jq treats null as 0 when it comes to addition
   # so there is no need to fiddle with the boundaries
  . as $old
  | reduce range(0; length) as $i
    ([];
     ($old[$i-1] + $old[$i+1]) as $s
     | if   $s == 0 then .[$i] = 0
       elif $s == 1 then .[$i] = (if $old[$i] == 1 then 1 else 0 end)
       else              .[$i] = (if $old[$i] == 1 then 0 else 1 end)
       end);


# pretty-print an array:
def pp: reduce .[] as $i (""; . + (if $i == 0 then " " else "*" end));

# continue until quiescence:
def go: recurse(. as $prev | next | if . == $prev then empty else . end) | pp;

# Example:
[0,1,1,1,0,1,1,0,1,0,1,0,1,0,1,0,0,1,0,0] | go
