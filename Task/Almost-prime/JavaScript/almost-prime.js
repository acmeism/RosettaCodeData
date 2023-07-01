function almostPrime (n, k) {
    var divisor = 2, count = 0
    while(count < k + 1 && n != 1) {
        if (n % divisor == 0) {
            n = n / divisor
            count = count + 1
        } else {
            divisor++
        }
    }
    return count == k
}

for (var k = 1; k <= 5; k++) {
    document.write("<br>k=", k, ": ")
    var count = 0, n = 0
    while (count <= 10) {
        n++
        if (almostPrime(n, k)) {
            document.write(n, " ")
            count++
        }
    }
}
