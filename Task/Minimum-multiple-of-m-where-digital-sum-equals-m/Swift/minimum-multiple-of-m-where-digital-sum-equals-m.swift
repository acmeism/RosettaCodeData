import Foundation

func digitSum(_ num: Int) -> Int {
    var sum = 0
    var n = num
    while n > 0 {
        sum += n % 10
        n /= 10
    }
    return sum
}

for n in 1...70 {
    for m in 1... {
        if digitSum(m * n) == n {
            print(String(format: "%8d", m), terminator: n % 10 == 0 ? "\n" : " ")
            break
        }
    }
}
