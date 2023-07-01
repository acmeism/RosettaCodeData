import "random" for Random
import "/fmt" for Fmt

var rand = Random.new()

var a = List.filled(20, null)
for (i in 0..19) {
    a[i] = List.filled(20, 0)
    for (j in 0..19) a[i][j] = rand.int(1, 21)
}

var found = false
for (i in 0..19) {
    for (j in 0..19) {
        System.write(Fmt.d(4, a[i][j]))
        if (a[i][j] == 20) {
            found = true
            break
        }
    }
    System.print()
    if (found) break
}
