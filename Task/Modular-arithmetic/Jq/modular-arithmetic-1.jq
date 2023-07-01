def assert($e; $msg): if $e then . else "assertion violation @ \($msg)" | error end;

def is_integer: type=="number" and floor == .;

# To take advantage of gojq's arbitrary-precision integer arithmetic:
def power($b): . as $in | reduce range(0;$b) as $i (1; . * $in);
