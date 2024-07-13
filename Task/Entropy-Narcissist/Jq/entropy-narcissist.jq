def chars: explode[] | [.] | implode;

def bow(stream):
  reduce stream as $word ({}; .[($word|tostring)] += 1);

def sum(s): reduce s as $x (0; .+$x);

length as $l
| bow(chars)
| sum(keys[] as $k | .[$k] as $c | $c * ($c|log2) )
| ($l|log2) - ./$l
