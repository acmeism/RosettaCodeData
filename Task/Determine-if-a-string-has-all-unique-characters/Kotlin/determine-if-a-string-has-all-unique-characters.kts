import java.util.HashMap

fun main() {
    System.out.printf("%-40s  %2s  %10s  %8s  %s  %s%n", "String", "Length", "All Unique", "1st Diff", "Hex", "Positions")
    System.out.printf("%-40s  %2s  %10s  %8s  %s  %s%n", "------------------------", "------", "----------", "--------", "---", "---------")
    for (s in arrayOf("", ".", "abcABC", "XYZ ZYX", "1234567890ABCDEFGHIJKLMN0PQRSTUVWXYZ")) {
        processString(s)
    }
}

private fun processString(input: String) {
    val charMap: MutableMap<Char, Int?> = HashMap()
    var dup = 0.toChar()
    var index = 0
    var pos1 = -1
    var pos2 = -1
    for (key in input.toCharArray()) {
        index++
        if (charMap.containsKey(key)) {
            dup = key
            pos1 = charMap[key]!!
            pos2 = index
            break
        }
        charMap[key] = index
    }
    val unique = if (dup.toInt() == 0) "yes" else "no"
    val diff = if (dup.toInt() == 0) "" else "'$dup'"
    val hex = if (dup.toInt() == 0) "" else Integer.toHexString(dup.toInt()).toUpperCase()
    val position = if (dup.toInt() == 0) "" else "$pos1 $pos2"
    System.out.printf("%-40s  %-6d  %-10s  %-8s  %-3s  %-5s%n", input, input.length, unique, diff, hex, position)
}
