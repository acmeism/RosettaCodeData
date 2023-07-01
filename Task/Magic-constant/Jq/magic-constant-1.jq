# To take advantage of gojq's arbitrary-precision integer arithmetic:
def power($b): . as $in | reduce range(0;$b) as $i (1; . * $in);

# nth-root
def iroot($n):
  . as $in
  | if $n == 1 then .
    else (. < 0) as $neg
    | if $neg and (n % 2) == 0
      then "Cannot take the \($n)th root of a negative number." | error
      else ($n-1) as $n
      | {t: (if $neg then -. else . end)}
      | .s = .t + 1
      | .u = .t
      | until (.u >= .s;
          .s = .u
          | .u = ((.u * $n) + (.t / (.u|power($n)))) / ($n + 1) )
      | if $neg then - .s else .s end
      end
    end;

# input: an array
# output: a stream of arrays of size size except possibly for the last array
def group(size):
  recurse( .[size:]; length>0) | .[0:size];

def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;

def ss : ["\u2070", "\u00b9", "\u00b2", "\u00b3", "\u2074",
          "\u2075", "\u2076", "\u2077", "\u2078", "\u2079"];

def superscript:
  if . < 10 then ss[.]
  elif . < 20 then ss[1] + ss[. - 10]
  else ss[2] + ss[0]
  end;
