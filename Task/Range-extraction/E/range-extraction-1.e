def rex(numbers :List[int]) {
    var region := 0..!0
    for n in numbers { region |= n..n }
    var ranges := []
    for interval in region.getSimpleRegions() {
        def a := interval.getOptStart()
        def b := interval.getOptBound() - 1
        ranges with= if (b > a + 1) {
                         `$a-$b`
                     } else if (b <=> a + 1) {
                         `$a,$b`
                     } else { # b <=> a
                         `$a`
                     }
    }
    return ",".rjoin(ranges)
}
