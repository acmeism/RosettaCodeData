use Prime::Factor;
use Lingua::EN::Numbers;

put (2..∞).hyper(:5000batch).map( {
    next if (1 < $_ gcd 210) || .is-prime || any .&prime-factors.map: -> $n { !.contains: $n };
    $_
} )[^20].batch(10)».&comma».fmt("%10s").join: "\n";
