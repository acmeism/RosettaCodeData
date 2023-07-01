def p1: "Traceback (most recent call last):";
def p2: "SystemError";
def sep: "----------------";

split("\n\n")[]
| index(p1) as $ix
| select( $ix and index(p2) )
| .[$ix:], sep
