import Foundation

struct PancakeSort {
    var arr:[Int]

    mutating func flip(n:Int) {
        for i in 0 ..< (n + 1) / 2 {
            swap(&arr[n - i], &arr[i])
        }
        println("flip(0.. \(n)): \(arr)")
    }

    func minmax(n:Int) -> [Int] {
        var xm = arr[0]
        var xM = arr[0]
        var posm = 0
        var posM = 0

        for i in 1..<n {
            if (arr[i] < xm) {
                xm = arr[i]
                posm = i
            } else if (arr[i] > xM) {
                xM = arr[i]
                posM = i
            }
        }

        return [posm, posM]
    }

    mutating func sort(var n:Int, var dir:Int) {
        if n == 0 {
            return
        }

        let mM = minmax(n)
        let bestXPos = mM[dir]
        let altXPos = mM[1 - dir]
        var flipped = false

        if bestXPos == n - 1 {
            n--
        } else if bestXPos == 0 {
            flip(n - 1)
            n--
        } else if altXPos == n - 1 {
            dir = 1 - dir
            n--
            flipped = true
        } else {
            flip(bestXPos)
        }

        sort(n, dir: dir)

        if flipped {
            flip(n)
        }
    }
}

let arr = [2, 3, 6, 1, 4, 5, 10, 8, 7, 9]
var a = PancakeSort(arr: arr)
a.sort(arr.count, dir: 1)
println(a.arr)
