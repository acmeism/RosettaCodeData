# Canonicalize a CIDR block: make sure none of the host bits are set
def canonicalize:
    # dotted-decimal / bits in network part
    (. / "/") as [$dotted, $bits]
    | ($bits | tonumber) as $size

    # get IP as binary string
    | {binary: (($dotted / ".") | map( tonumber | convert(2) | lpad(8; "0") ) | join("") )}

    # replace the host part with all zeros
    | .binary |= .[0:$size] + "0" * (32 - $size)

    # convert back to dotted-decimal
    | [.binary | explode | _nwise(8) | implode]
    | (map( to_i(2) | tostring ) | join(".")) as $canon

    | $canon + "/" + $bits;

def tests:
    "87.70.141.1/22",
    "36.18.154.103/12",
    "62.62.197.11/29",
    "67.137.119.181/4",
    "161.214.74.21/24",
    "184.232.176.184/18"
;

tests
| "\(lpad(18)) -> \(canonicalize)"
