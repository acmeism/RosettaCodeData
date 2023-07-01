def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;

def is_prime:
  multiple(factors) | not;

def tobase($b):
  def digit: "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"[.:.+1];
  def mod: . % $b;
  def div: ((. - mod) / $b);
  def digits: recurse( select(. > 0) | div) | mod ;
  # For jq it would be wise to protect against `infinite` as input, but using `isinfinite` confuses gojq
  select( (tostring|test("^[0-9]+$")) and 2 <= $b and $b <= 36)
  | if . == 0 then "0"
    else [digits | digit] | reverse[1:] | add
    end;

# emit the decimal values of the "digits"
def digits($b):
  def mod: . % $b;
  def div: ((. - mod) / $b);
  butlast(recurse( select(. > 0) | div) | mod) ;
