select(length > 10)
| . as $w
| select( all("a","e","i","o","u";
               . as $v | ($w | test($v) and (test( "\($v).*\($v)")|not))))
