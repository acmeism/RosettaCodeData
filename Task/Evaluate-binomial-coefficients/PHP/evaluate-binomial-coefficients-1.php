<?php
$n=5;
$k=3;
function factorial($val){
    for($f=2;$val-1>1;$f*=$val--);
    return $f;
}
$binomial_coefficient=factorial($n)/(factorial($k)*factorial($n-$k));
echo $binomial_coefficient;
?>
