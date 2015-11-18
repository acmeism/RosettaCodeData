<?php
class sdcalc {
    private  $cnt, $sumup, $square;

    function __construct() {
       $this->reset();
    }
    # callable on an instance
    function reset() {
       $this->cnt=0; $this->sumup=0; $this->square=0;
    }
    function add($f) {
        $this->cnt++;
        $this->sumup  += $f;
        $this->square += pow($f, 2);
        return $this->calc();
    }
    function calc() {
        if ($this->cnt==0 || $this->sumup==0) {
            return 0;
        } else {
            return sqrt($this->square / $this->cnt - pow(($this->sumup / $this->cnt),2));
        }
    }
 }

# start test, adding test data one by one
$c = new sdcalc();
foreach ([2,4,4,4,5,5,7,9] as $v) {
    printf('Adding %g: result %g%s', $v, $c->add($v), PHP_EOL);
}
