class BinarySearch {
    static recursive(a, value, low, high) {
        if (high < low) return -1
        var mid = low + ((high - low)/2).floor
        if (a[mid] > value) return recursive(a, value, low, mid-1)
        if (a[mid] < value) return recursive(a, value, mid+1, high)
        return mid
    }

    static iterative(a, value) {
        var low = 0
        var high = a.count - 1
        while (low <= high) {
            var mid = low + ((high - low)/2).floor
            if (a[mid] > value) {
                high = mid - 1
            } else if (a[mid] < value) {
                low = mid + 1
            } else {
                return mid
            }
        }
        return -1
    }
}

var a = [10, 22, 45, 67, 89, 97]
System.print("array = %(a)")

System.print("\nUsing the recursive algorithm:")
for (value in [67, 93]) {
    var index = BinarySearch.recursive(a, value, 0, a.count - 1)
    if (index >= 0) {
        System.print("  %(value) was found at index %(index) of the array.")
    } else {
        System.print("  %(value) was not found in the array.")
    }
}

System.print("\nUsing the iterative algorithm:")
for (value in [22, 70]) {
    var index = BinarySearch.iterative(a, value)
    if (index >= 0) {
        System.print("  %(value) was found at index %(index) of the array.")
    } else {
        System.print("  %(value) was not found in the array.")
    }
}
