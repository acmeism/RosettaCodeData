set keys   [list fred bob joe]
set values [list barber plumber tailor]
array set arr {}
foreach a $keys b $values { set arr($a) $b }

parray arr
