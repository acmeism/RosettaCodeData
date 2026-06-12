def is_upper: . >= "A" and . <= "Z";

def is_lower: . >= "a" and . <= "z";

# Output: a stream
def chars: explode[] | [.] | implode;

# (*) Change to `keys` for gojq
def key($s): first( keys_unsorted[] as $k | if .[$k] == $s then $k else empty end) // "?";
