# If your jq has while/2 then the following definition can be omitted:
def while(cond; update):
  def _while: if cond then ., (update | _while) else empty end;
  _while;

# subleq(a) runs the program, a, an array of integers.
# Input: the data
# When the subleq OSIC is about to emit a NUL character, it stops instead.
def subleq(a):
  . as $input
  # state: [i, indexIntoInput, a, output]
  | [0, 0, a]
  | while( .[0] >= 0 and .[3] != 0 ;
           .[0] as $i
           | .[1] as $ix
           | .[2] as $a
           | if $a[$i] == -1 then
                if $input and $ix < ($input|length)
                then [$i+3, $ix + 1, ($a[$a[$i + 1]] = $input[$ix]), null]
                else [-1]
                end
              elif $a[$i + 1] == -1 then [$i+3, $ix, $a, $a[$a[$i]]]
              else
                [$i, $ix, ($a | .[.[$i + 1]] -= .[.[$i]]), null]
                | .[2] as $a
                | if $a[$a[$i+1]] <= 0 then .[0] = $a[$i + 2] else . end
                | .[0] += 3
              end )
  | .[3] | select(.) | [.] | implode;

subleq([15, 17, -1, 17, -1, -1, 16, 1, -1, 16, 3, -1, 15, 15,  0, 0, -1,
        72, 101, 108, 108, 111, 44, 32, 119, 111, 114, 108, 100, 33, 10, 0])
