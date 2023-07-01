// version 1.2.31

const val INDENT = 2

fun String.parseSExpr(): List<String>? {
    val r = Regex("""\s*("[^"]*"|\(|\)|"|[^\s()"]+)""")
    val t = r.findAll(this).map { it.value }.toMutableList()
    if (t.size == 0) return null
    var o = false
    var c = 0
    for (i in t.size - 1 downTo 0) {
        val ti = t[i].trim()
        val nd = ti.toDoubleOrNull()
        if (ti == "\"") return null
        if (ti == "(") {
            t[i] = "["
            c++
        }
        else if (ti == ")") {
            t[i] = "]"
            c--
        }
        else if (nd != null) {
             val ni = ti.toIntOrNull()
             if (ni != null) t[i] = ni.toString()
             else t[i] = nd.toString()
        }
        else if (ti.startsWith("\"")) { // escape embedded double quotes
             var temp = ti.drop(1).dropLast(1)
             t[i] = "\"" + temp.replace("\"", "\\\"") + "\""
        }
        if (i > 0 && t[i] != "]" && t[i - 1].trim() != "(") t.add(i, ", ")
        if (c == 0) {
            if (!o) o = true else return null
        }
    }
    return if (c != 0) null else t
}

fun MutableList<String>.toSExpr(): String {
    for (i in 0 until this.size) {
        this[i] = when (this[i]) {
            "["  -> "("
            "]"  -> ")"
            ", " -> " "
            else ->  {
                if (this[i].startsWith("\"")) { // unescape embedded quotes
                    var temp = this[i].drop(1).dropLast(1)
                    "\"" + temp.replace("\\\"", "\"") + "\""
                }
                else this[i]
            }
        }
    }
    return this.joinToString("")
}

fun List<String>.prettyPrint() {
    var level = 0
    loop@for (t in this) {
        var n: Int
        when(t) {
            ", ", " " -> continue@loop
            "[", "(" -> {
                n = level * INDENT + 1
                level++
             }
             "]", ")" -> {
                level--
                n = level * INDENT + 1
             }
             else -> {
                n = level * INDENT + t.length
             }
        }
        println("%${n}s".format(t))
    }
}

fun main(args: Array<String>) {
    val str = """((data "quoted data" 123 4.5)""" + "\n" +
              """ (data (!@# (4.5) "(more" "data)")))"""
    val tokens = str.parseSExpr()
    if (tokens == null)
        println("Invalid s-expr!")
    else {
        println("Native data structure:")
        println(tokens.joinToString(""))
        println("\nNative data structure (pretty print):")
        tokens.prettyPrint()

        val tokens2 = tokens.toMutableList()
        println("\nRecovered S-Expression:")
        println(tokens2.toSExpr())
        println("\nRecovered S-Expression (pretty print):")
        tokens2.prettyPrint()
    }
}
