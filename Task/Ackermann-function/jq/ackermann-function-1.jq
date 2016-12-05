# input: [m,n]
def ack:
  .[0] as $m | .[1] as $n
  | if $m == 0 then $n + 1
    elif $n == 0 then [$m-1, 1] | ack
    else [$m-1, ([$m, $n-1 ] | ack)] | ack
    end ;
