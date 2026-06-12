# The def of _nwise/1 is included here in case gojq or fq is used.
def _nwise($n):
  def nw: if length <= $n then . else .[0:$n] , (.[$n:] | nw) end;
  nw;

def chars: explode[] | [.] | implode;

# decimal number to hex string using lower-case letters
def hex:
  def stream:
    recurse(if . > 0 then ./16|floor else empty end) | . % 16 ;
  if . == 0 then "0"
  else [stream] | reverse | .[1:]
  |  map(if . < 10 then 48 + . else . + 87 end) | implode
  end;

def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;

# Emit a stream of same-digit numbers, up to .
def sameDigitSettasktask:
  def u: [tostring|chars] | unique;
  range(0; .) | select((hex|u) == u);

# The task
1e5
| "Numbers under \(.) which use the same digits in decimal as in hex:",
  ( [sameDigitSettasktask]
    | map(lpad(6))
    | ((_nwise(10) | join(" ")),
       "\n\(length) such numbers found." ) )
