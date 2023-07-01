import "random" for Random

var r = Random.new()
while (true) {
    var n = r.int(20)
    System.print(n)
    if (n == 10) break
    System.print(r.int(20))
}
