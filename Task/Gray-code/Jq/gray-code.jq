def encode:
  def flip: if . == 1 then 0 else 1 end;
  . as $b
  | reduce range(1; length) as $i ($b;
     if $b[$i-1] == 1 then .[$i] |= flip
     else .
     end ) ;

def decode:
  def xor($a;$b): ($a + $b) % 2;
  . as $g
  | reduce range(1; length) as $i (.[:1];
      .[$i] = xor($g[$i]; .[$i-1]) ) ;


# input: a non-negative integer
# output: a binary array, least-significant bit first
def to_binary:
  if . == 0 then [0]
  else [recurse( if . == 0 then empty else ./2 | floor end ) % 2]
    | .[:-1] # remove the uninteresting 0
  end ;

def lpad($len; $fill):
  tostring
  | ($len - length) as $l
  | if $l <= 0 then .
    else ($fill * $l)[:$l] + .
    end;

def pp: map(tostring) | join("") | lpad(5; "0");

### The task
"decimal   binary    gray  roundtrip",
(range(0; 32) as $i
 | ($i | to_binary | reverse) as $b
 | ($b|encode) as $g
 | "  \($i|lpad(2;" "))       \($b|pp)   \($g|pp)   \($g|decode == $b)" )
