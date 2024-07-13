fun <T : Comparable<T>> Array<T>.insertionSort() {
    for (i in 1..lastIndex) {
        val currentElement = this[i]
        var low = 0
        var high = i - 1
        while (low <= high) {
            val mid = low + (high - low) / 2
            if (this[mid] <= currentElement)
                low = mid + 1
            else
                high = mid - 1
        }
        copyInto(this, low + 1, low, i)
        this[low] = currentElement
    }
}
