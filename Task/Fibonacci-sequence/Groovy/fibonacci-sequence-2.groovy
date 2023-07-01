def iFib = {
    it == 0   ? 0
    : it == 1 ? 1
    : it > 1  ? (2..it).inject([0,1]){i, j -> [i[1], i[0]+i[1]]}[1]
    /*it < 0*/: (-1..it).inject([0,1]){i, j -> [i[1]-i[0], i[0]]}[0]
}
