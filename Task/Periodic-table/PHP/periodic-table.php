<?php
// Periodic table

class PeriodicTable
{
    private $aArray = array(1, 2, 5, 13, 57, 72, 89, 104);

    private $bArray = array(-1, 15, 25, 35, 72, 21, 58, 7);

    public function rowAndColumn($n)
    {
        $i = 7;
        while ($this->aArray[$i] > $n)
            $i--;
        $m = $n + $this->bArray[$i];
        return array(floor($m / 18) + 1, $m % 18 + 1);
    }
}

$pt = new PeriodicTable();
// Example elements (atomic numbers).
foreach ([1, 2, 29, 42, 57, 58, 72, 89, 90, 103] as $n) {
    list($r, $c) = $pt->rowAndColumn($n);
    echo $n, " -> ", $r, " ", $c, PHP_EOL;
}
?>
