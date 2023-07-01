CHARS = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ'

int checksum(String prefix) {
    def digits = prefix.toUpperCase().collect { CHARS.indexOf(it).toString() }.sum()
    def groups = digits.collect { CHARS.indexOf(it) }.inject([[], []]) { acc, i -> [acc[1], acc[0] + i] }
    def ds = groups[1].collect { (2 * it).toString() }.sum().collect { CHARS.indexOf(it) } + groups[0]
    (10 - ds.sum() % 10) % 10
}

assert checksum('AU0000VXGZA') == 3
assert checksum('GB000263494') == 6
assert checksum('US037833100') == 5
assert checksum('US037833107') == 0
