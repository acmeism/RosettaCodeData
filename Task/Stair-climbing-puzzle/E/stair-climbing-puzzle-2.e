def stepUpCounting() {
    var deficit := 1
    while (deficit > 0) {
        deficit += step().pick(-1, 1)
    }
}
