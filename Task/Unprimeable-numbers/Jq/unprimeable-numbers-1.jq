def digits: tostring | explode | map([.] | implode | tonumber);

def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;
