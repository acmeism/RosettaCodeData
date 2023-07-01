function is_disarium (num) {
    let n = num
    let len = n.toString().length
    let sum = 0
    while (n > 0) {
        sum += (n % 10) ** len
        n = parseInt(n / 10, 10)
        len--
    }
    return num == sum
}
let count = 0
let i = 1
while (count < 18) {
    if (is_disarium(i)) {
        process.stdout.write(i + " ")
        count++
    }
    i++
}
