# Input: $n
def zs($a; $b):
  . as $n
  | (($a|power($n)) - ($b|power($n))) as $dn
  | if ($dn|isPrime) then $dn
    else ([$dn|divisors]|sort) as $divs
    | [range(1; $n) as $m | ($a|power($m)) - ($b|power($m))] as $dms
    | first( range( $divs|length-1; 0 ; -1) as $i
        | if (all($dms[]; gcd(.; $divs[$i]) == 1 )) then $divs[$i] else empty end)
       // 1
  end;
