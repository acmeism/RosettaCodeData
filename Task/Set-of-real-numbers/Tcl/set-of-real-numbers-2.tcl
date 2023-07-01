foreach {str Set} {
    {(0, 1] ∪ [0, 2)} {
	union [realset {(0,1]}] [realset {[0,2)}]
    }
    {[0, 2) ∩ (1, 2]} {
	intersection [realset {[0,2)}] [realset {(1,2]}]
    }
    {[0, 3) − (0, 1)} {
	difference [realset {[0,3)}] [realset {(0,1)}]
    }
    {[0, 3) − [0, 1]} {
	difference [realset {[0,3)}] [realset {[0,1]}]
    }
} {
    set Set [eval $Set]
    foreach x {0 1 2} {
	puts "$x : $str :\t[elementOf $x $Set]"
    }
}
