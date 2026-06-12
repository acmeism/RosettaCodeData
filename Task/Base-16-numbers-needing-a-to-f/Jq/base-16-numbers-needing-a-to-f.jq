# decimal number to hex string using lower-case letters
def hex:
  def stream:
    recurse(if . >= 16 then ./16|floor else empty end) | . % 16 ;
  [stream] | reverse
  |  map(if . < 10 then 48 + . else . + 87 end) | implode
  end;


# For pretty-printing
def nwise($n):
  def n: if length <= $n then . else .[0:$n] , (.[$n:] | n) end;
  n;

def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;

def task:
  ["a","b","c","d","e","f"] as $letters
  | [ range(1;501)
     | (hex | explode | map([.]|implode)) as $hex
     | select( any($hex[]; IN( $letters[] )))]
  | nwise(10) | map(lpad(4)) | join("")
  ;
task
