<?php
class PilesHeap extends SplMinHeap {
    public function compare($pile1, $pile2) {
        return parent::compare($pile1->top(), $pile2->top());
    }
}

function patience_sort(&$n) {
    $piles = array();
    // sort into piles
    foreach ($n as $x) {
        // binary search
        $low = 0; $high = count($piles)-1;
        while ($low <= $high) {
            $mid = (int)(($low + $high) / 2);
            if ($piles[$mid]->top() >= $x)
                $high = $mid - 1;
            else
                $low = $mid + 1;
        }
        $i = $low;
        if ($i == count($piles))
            $piles[] = new SplStack();
        $piles[$i]->push($x);
    }

    // priority queue allows us to merge piles efficiently
    $heap = new PilesHeap();
    foreach ($piles as $pile)
        $heap->insert($pile);
    for ($c = 0; $c < count($n); $c++) {
        $smallPile = $heap->extract();
        $n[$c] = $smallPile->pop();
        if (!$smallPile->isEmpty())
        $heap->insert($smallPile);
    }
    assert($heap->isEmpty());
}

$a = array(4, 65, 2, -31, 0, 99, 83, 782, 1);
patience_sort($a);
print_r($a);
?>
