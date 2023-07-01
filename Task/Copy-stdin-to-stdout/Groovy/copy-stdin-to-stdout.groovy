class StdInToStdOut {
    static void main(args) {
        try (def reader = System.in.newReader()) {
            def line
            while ((line = reader.readLine()) != null) {
                println line
            }
        }
    }
}
