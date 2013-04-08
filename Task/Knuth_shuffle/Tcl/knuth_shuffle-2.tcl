% for {set i 0} {$i<100000} {incr i} {
    foreach val [knuth_shuffle {1 2 3 4 5}] pos {pos0 pos1 pos2 pos3 pos4} {
        incr tots($pos) $val
    }
}
% parray tots
tots(pos0) = 300006
tots(pos1) = 300223
tots(pos2) = 299701
tots(pos3) = 299830
tots(pos4) = 300240
