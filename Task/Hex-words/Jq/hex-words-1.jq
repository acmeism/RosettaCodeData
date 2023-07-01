def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;

# . may be a decimal number or a string representing a decimal number
def digital_root:
  # string-only version
  def dr:
    # state: [mdr, persist]
    until( .[0] | length == 1;
              [ (.[0] | explode | map(.-48) | add | tostring), .[1] + 1 ]
              );
  [tostring, 0] | dr | .[0] | tonumber;

# lowercase a-f
def isHexWord:
  all(explode[]; 97 <= . and . <= 102);

# Input: a valid hex number (all lowercase)
def hex2i:
  def toi: if . >= 87 then .-87 else . - 48 end;
  reduce (explode | map(toi) | reverse[]) as $i ([1, 0]; # [power, sum]
    .[1] += $i * .[0]
    | .[0] *= 16 )
  | .[1];
