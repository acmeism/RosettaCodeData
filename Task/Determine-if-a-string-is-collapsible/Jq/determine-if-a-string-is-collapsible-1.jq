# Input: an array
# Output: a stream
def uniq: foreach .[] as $x ({x:nan, y:.[0]}; {x:$x, y:.x}; select(.x != .y) | .x);

def collapse: explode | [uniq] | implode;
