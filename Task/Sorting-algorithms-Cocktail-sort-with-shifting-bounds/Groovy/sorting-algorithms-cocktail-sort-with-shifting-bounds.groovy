class CocktailSort {
    static void main(String[] args) {
        Integer[] array = [ 5, 1, -6, 12, 3, 13, 2, 4, 0, 15 ]
        println("before: " + Arrays.toString(array))
        cocktailSort(array)
        println("after: " + Arrays.toString(array))
    }

    // Sorts an array of elements that implement the Comparable interface
    static void cocktailSort(Object[] array) {
        int begin = 0
        int end = array.length
        if (end == 0) {
            return
        }
        for (--end; begin < end; ) {
            int new_begin = end
            int new_end = begin
            for (int i = begin; i < end; ++i) {
                Comparable c1 = (Comparable)array[i]
                Comparable c2 = (Comparable)array[i + 1]
                if (c1 > c2) {
                    swap(array, i, i + 1)
                    new_end = i
                }
            }
            end = new_end
            for (int i = end; i > begin; --i) {
                Comparable c1 = (Comparable)array[i - 1]
                Comparable c2 = (Comparable)array[i]
                if (c1 > c2) {
                    swap(array, i, i - 1)
                    new_begin = i
                }
            }
            begin = new_begin
        }
    }

    private static void swap(Object[] array, int i, int j) {
        Object tmp = array[i]
        array[i] = array[j]
        array[j] = tmp
    }
}
