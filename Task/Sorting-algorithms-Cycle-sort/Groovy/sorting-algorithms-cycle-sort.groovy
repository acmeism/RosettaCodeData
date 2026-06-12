class CycleSort {
    static void main(String[] args) {
        int[] arr = [5, 0, 1, 2, 2, 3, 5, 1, 1, 0, 5, 6, 9, 8, 0, 1]

        println(Arrays.toString(arr))

        int writes = cycleSort(arr)
        println(Arrays.toString(arr))
        println("writes: " + writes)
    }

    static int cycleSort(int[] a) {
        int writes = 0

        for (int cycleStart = 0; cycleStart < a.length - 1; cycleStart++) {
            int val = a[cycleStart]

            // count the number of values that are smaller than val
            // since cycleStart
            int pos = cycleStart
            for (int i = cycleStart + 1; i < a.length; i++) {
                if (a[i] < val) {
                    pos++
                }
            }

            // there aren't any
            if (pos == cycleStart) {
                continue
            }

            // skip duplicates
            while (val == a[pos]) {
                pos++
            }

            // put val into final position
            int tmp = a[pos]
            a[pos] = val
            val = tmp
            writes++

            // repeat as long as we can find values to swap
            // otherwise start new cycle
            while (pos != cycleStart) {
                pos = cycleStart
                for (int i = cycleStart + 1; i < a.length; i++) {
                    if (a[i] < val) {
                        pos++
                    }
                }

                while (val == a[pos]) {
                    pos++
                }

                tmp = a[pos]
                a[pos] = val
                val = tmp
                writes++
            }
        }
        return writes
    }
}
