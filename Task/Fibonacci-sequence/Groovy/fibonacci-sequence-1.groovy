def rFib
rFib = {
    it == 0   ? 0
    : it == 1 ? 1
    : it > 1  ? rFib(it-1) + rFib(it-2)
    /*it < 0*/: rFib(it+2) - rFib(it+1)

}
