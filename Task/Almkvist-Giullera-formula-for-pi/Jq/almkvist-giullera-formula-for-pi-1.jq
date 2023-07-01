# A reminder to include the "rational" module:
# include "rational";

def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;

# To take advantage of gojq's arbitrary-precision integer arithmetic:
def power($b): . as $in | reduce range(0;$b) as $i (1; . * $in);

def factorial:
    if . < 2 then 1
    else reduce range(2;.+1) as $i (1; .*$i)
    end;
