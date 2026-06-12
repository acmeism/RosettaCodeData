import "./seq" for Lst
import "./fmt" for Fmt
import "./big" for BigInt, BigInts

// Returns true if the permutation has the zigzag property otherwise false.
var isZigzag = Fn.new { |arr|
    if (arr.count < 2) return true
    for (i in 0 ... arr.count - 1) {
        if (i % 2 == 0) {
            if (arr[i] >= arr[i + 1]) return false
        } else {
            if (arr[i] <= arr[i + 1]) return false
        }
    }
    return true
}

// Mutates 'arr' into the next permutation with the zigzag property.
// Returns true if a new permutation was found, otherwise false.
var nextZigzagPerm = Fn.new { |arr|
    while (true) {
        if (arr.count <= 1) break
        // Find last index where arr[i] < arr[i + 1].
        var i = -1
        for (idx in arr.count - 2..0) {
            if (arr[idx] < arr[idx + 1]) {
                i = idx
                break
            }
        }
        if (i == -1) {
            Lst.reverse(arr)  // reverse the array in place
            break
        }
        // Find last index where arr[j] > arr[i].
        var j = i + 1
        for (idx in arr.count - 1 .. i + 1) {
            if (arr[idx] > arr[i]) {
                j = idx
                break
            }
        }
        // Swap elements at i and j.
        arr.swap(i, j)
        // Reverse the sub-array from i + 1 to end in place.
        var subarr = arr[i + 1..-1]  // creates new list
        subarr = subarr[-1..0]       // ditto
        var k = i + 1                // prepare to copy back to 'arr'
        for (i in i + 1...arr.count) arr[i] = subarr[i - k]
        if (isZigzag.call(arr)) return true
    }
    return false
}

var testZigzags = Fn.new { |nListings, nTotals|
    // Generate zigzag permutation listings and print totals.
    for (n in 1..nListings) {
        System.print("\nZigzag Permuations for N = %(n):")
        var arr = (1..n).toList
        if (n < 3) {
            System.print(arr)
        } else {
            while (nextZigzagPerm.call(arr)) System.write("%(arr) ")
            System.print()
        }
    }

    var zzn = [BigInt.one]
    System.print("\n N    Zigzags\n--------------------------------")
    System.print(" 1    1")
    for (m in 1...nTotals) {
        var cumsum = []
        var total = BigInt.zero
        if (m % 2 == 0) {
            for (x in zzn[-1..0]) {
                total = total + x
                cumsum.add(total)
            }
            zzn = cumsum[-1..0] + [BigInt.zero]
        } else {
            for (x in zzn) {
                total = total + x
                cumsum.add(total)
            }
            zzn = [BigInt.zero] + cumsum
        }
        Fmt.print("$2d    $i", m + 1, BigInts.sum(zzn))
    }
}

testZigzags.call(5, 30)
