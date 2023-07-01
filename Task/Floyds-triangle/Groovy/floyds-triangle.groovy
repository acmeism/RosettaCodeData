class Floyd {
    static void main(String[] args) {
        printTriangle(5)
        printTriangle(14)
    }

    private static void printTriangle(int n) {
        println(n + " rows:")
        int printMe = 1
        int numsPrinted = 0
        for (int rowNum = 1; rowNum <= n; printMe++) {
            int cols = (int) Math.ceil(Math.log10(n * (n - 1) / 2 + numsPrinted + 2))
            printf("%" + cols + "d ", printMe)
            if (++numsPrinted == rowNum) {
                println()
                rowNum++
                numsPrinted = 0
            }
        }
    }
}
