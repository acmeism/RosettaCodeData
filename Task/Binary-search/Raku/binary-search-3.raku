sub binary_search (&p, Int $lo, Int $hi --> Int) {
    $lo <= $hi or fail;
    my Int $mid = ($lo + $hi) div 2;
    given p $mid {
        when -1 { binary_search &p, $lo,      $mid - 1 }
        when  1 { binary_search &p, $mid + 1, $hi      }
        default { $mid                                 }
    }
}
