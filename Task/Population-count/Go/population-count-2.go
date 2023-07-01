func pop64(w uint64) int {
    const (
        ff    = 1<<64 - 1
        mask1 = ff / 3
        mask3 = ff / 5
        maskf = ff / 17
        maskp = maskf >> 3 & maskf
    )
    w -= w >> 1 & mask1
    w = w&mask3 + w>>2&mask3
    w = (w + w>>4) & maskf
    return int(w * maskp >> 56)
}
