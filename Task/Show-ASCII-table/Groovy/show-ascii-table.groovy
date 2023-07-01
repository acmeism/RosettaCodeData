class ShowAsciiTable {
    static void main(String[] args) {
        for (int i = 32; i <= 127; i++) {
            if (i == 32 || i == 127) {
                String s = i == 32 ? "Spc" : "Del"
                printf("%3d: %s ", i, s)
            } else {
                printf("%3d: %c   ", i, i)
            }
            if ((i - 1) % 6 == 0) {
                println()
            }
        }
    }
}
