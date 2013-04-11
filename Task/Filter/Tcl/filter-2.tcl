foreach {key val} [array get srcArray] {
    if {[string is integer -strict $key] && !($key%2)} {
        set dstArray($key) $val
    }
}
