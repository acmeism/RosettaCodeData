import "./seq" for Lst

var lls = [
    [[2, 5, 1, 3, 8, 9, 4, 6], [3, 5, 6, 2, 9, 8, 4], [1, 3, 7, 6, 9]],
    [[2, 2, 1, 3, 8, 9, 4, 6], [3, 5, 6, 2, 2, 2, 4], [2, 3, 7, 6, 2]]
]

for (ll in lls) {
    System.print(Lst.intersect(ll[0], Lst.intersect(ll[1], ll[2])))
}
