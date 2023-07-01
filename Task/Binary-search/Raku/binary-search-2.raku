sub binary_search (&p, Int $lo is copy, Int $hi is copy --> Int) {
    until $lo > $hi {
        my Int $mid = ($lo + $hi) div 2;
        given p $mid {
            when -1 { $hi = $mid - 1; }
            when  1 { $lo = $mid + 1; }
            default { return $mid;    }
        }
    }
    fail;
}
