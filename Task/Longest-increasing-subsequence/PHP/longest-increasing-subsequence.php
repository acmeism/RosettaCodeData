<?php
class Node {
    public $val;
    public $back = NULL;
}

function lis($n) {
    $pileTops = array();
    // sort into piles
    foreach ($n as $x) {
        // binary search
        $low = 0; $high = count($pileTops)-1;
        while ($low <= $high) {
            $mid = (int)(($low + $high) / 2);
            if ($pileTops[$mid]->val >= $x)
                $high = $mid - 1;
            else
                $low = $mid + 1;
        }
        $i = $low;
        $node = new Node();
        $node->val = $x;
        if ($i != 0)
            $node->back = $pileTops[$i-1];
        $pileTops[$i] = $node;
    }
    $result = array();
    for ($node = count($pileTops) ? $pileTops[count($pileTops)-1] : NULL;
         $node != NULL; $node = $node->back)
        $result[] = $node->val;

    return array_reverse($result);
}

print_r(lis(array(3, 2, 6, 4, 5, 1)));
print_r(lis(array(0, 8, 4, 12, 2, 10, 6, 14, 1, 9, 5, 13, 3, 11, 7, 15)));
?>
