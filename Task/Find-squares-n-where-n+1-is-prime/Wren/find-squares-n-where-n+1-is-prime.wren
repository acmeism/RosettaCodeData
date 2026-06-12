import "./math" for Int

var squares = []
var limit = 1000.sqrt.floor
var i = 1
while (i <= limit) {
    var n = i * i
    if (Int.isPrime(n+1)) squares.add(n)
    i = (i == 1) ? 2 : i + 2
}
System.print("There are %(squares.count) square numbers 'n' where 'n+1' is prime, viz:")
System.print(squares)
