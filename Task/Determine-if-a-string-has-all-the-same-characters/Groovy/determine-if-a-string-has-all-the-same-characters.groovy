class Main {
    static void main(String[] args) {
        String[] tests = ["", "   ", "2", "333", ".55", "tttTTT", "4444 444k"]
        for (String s : tests) {
            analyze(s)
        }
    }

    static void analyze(String s) {
        println("Examining [$s] which has a length of ${s.length()}")
        if (s.length() > 1) {
            char firstChar = s.charAt(0)
            int lastIndex = s.lastIndexOf(firstChar as String)
            if (lastIndex != 0) {
                println("\tNot all characters in the string are the same.")
                println("\t'$firstChar' (0x${Integer.toHexString(firstChar as Integer)}) is different at position $lastIndex")
                return
            }
        }
        println("\tAll characters in the string are the same.")
    }
}
