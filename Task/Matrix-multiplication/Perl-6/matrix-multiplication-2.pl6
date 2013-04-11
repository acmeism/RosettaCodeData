sub mmult(@a,@b) {
    for ^@a -> $r {[
        for ^@b[0] -> $c {
            [+] (@a[$r][^@b] Z* @b[^@b]»[$c])
        }
    ]}
}
