class MainKt {
    // Data classes for better structure
    private data class Token(val value: Any, val isSequence: Boolean)

    private class Sequence(vararg items: Any) : ArrayList<Any>() {
        init {
            addAll(items)
        }
    }

    private var src: String = ""
    private var ch: Char = ' '
    private var sdx: Int = 0
    private var token: Token = Token(-1, false)
    private var err: Boolean = false
    private val idents = mutableListOf<String>()
    private val ididx = mutableListOf<Int>()
    private val productions = mutableListOf<Sequence>()
    private val extras = Sequence()
    private val results = arrayOf("pass", "fail")

    private fun Boolean.toInt() = if (this) 1 else 0

    private fun invalid(msg: String): Int {
        err = true
        println(msg)
        sdx = src.length // set to eof
        return -1
    }

    private fun skipSpaces() {
        while (sdx < src.length) {
            ch = src[sdx]
            if (ch !in " \t\r\n") {
                break
            }
            sdx++
        }
    }

    private fun getToken() {
        // Yields a single character token, one of {}()[]|=.;
        // or {"terminal",string} or {"ident", string} or -1.
        skipSpaces()
        if (sdx >= src.length) {
            token = Token(-1, false)
            return
        }
        val tokstart = sdx
        when {
            ch in "{}()[]|=.;" -> {
                sdx++
                token = Token(ch, false)
            }
            ch == '"' || ch == '\'' -> {
                val closech = ch
                var tokend = tokstart + 1
                while (tokend < src.length && src[tokend] != closech) {
                    tokend++
                }
                if (tokend >= src.length) {
                    token = Token(invalid("no closing quote"), false)
                } else {
                    sdx = tokend + 1
                    token = Token(Sequence("terminal", src.substring(tokstart + 1, tokend)), true)
                }
            }
            ch in 'a'..'z' -> {
                // To simplify things for the purposes of this task,
                // identifiers are strictly a-z only, not A-Z or 1-9.
                while (sdx < src.length && ch in 'a'..'z') {
                    sdx++
                    if (sdx < src.length) {
                        ch = src[sdx]
                    }
                }
                token = Token(Sequence("ident", src.substring(tokstart, sdx)), true)
            }
            else -> {
                token = Token(invalid("invalid ebnf"), false)
            }
        }
    }

    private fun matchToken(expectedCh: Char) {
        if (token.value != expectedCh) {
            token = Token(invalid("invalid ebnf ($expectedCh expected)"), false)
        } else {
            getToken()
        }
    }

    private fun addIdent(ident: String): Int {
        var k = idents.indexOf(ident)
        if (k == -1) {
            idents.add(ident)
            k = idents.size - 1
            ididx.add(-1)
        }
        return k
    }

    private fun factor(): Any {
        val res: Any = when {
            token.isSequence -> {
                val t = token.value as Sequence
                if (t[0] == "ident") {
                    val idx = addIdent(t[1] as String)
                    t.add(idx)
                    token = Token(t, true)
                }
                val result = token.value
                getToken()
                result
            }
            token.value == '[' -> {
                getToken()
                val result = Sequence("optional", expression())
                matchToken(']')
                result
            }
            token.value == '(' -> {
                getToken()
                val result = expression()
                matchToken(')')
                result
            }
            token.value == '{' -> {
                getToken()
                val result = Sequence("repeat", expression())
                matchToken('}')
                result
            }
            else -> throw RuntimeException("invalid token in factor() function")
        }
        return if (res is Sequence && res.size == 1) res[0] else res
    }

    private fun term(): Any {
        val res = Sequence(factor())
        val tokens = setOf(-1, '|', '.', ';', ')', ']', '}')

        while (token.value !in tokens) {
            res.add(factor())
        }

        return if (res.size == 1) res[0] else res
    }

    private fun expression(): Any {
        var res = Sequence(term())
        if (token.value == '|') {
            res = Sequence("or", res[0])
            while (token.value == '|') {
                getToken()
                res.add(term())
            }
        }
        return if (res.size == 1) res[0] else res
    }

    private fun production(): Any {
        // Returns a token or -1; the real result is left in 'productions' etc,
        getToken()
        if (token.value != '}') {
            if (token.value == -1) {
                return invalid("invalid ebnf (missing closing })")
            }
            if (!token.isSequence) {
                return -1
            }
            val t = token.value as Sequence
            if (t[0] != "ident") {
                return -1
            }
            val ident = t[1] as String
            val idx = addIdent(ident)
            getToken()
            matchToken('=')
            if (token.value == -1) {
                return -1
            }
            productions.add(Sequence(ident, idx, expression()))
            ididx[idx] = productions.size - 1
        }
        return token.value
    }

    private fun parse(ebnf: String): Int {
        // Returns +1 if ok, -1 if bad.
        println("parse:\n$ebnf ===>\n")
        err = false
        src = ebnf
        sdx = 0
        idents.clear()
        ididx.clear()
        productions.clear()
        extras.clear()

        getToken()
        if (token.isSequence) {
            val t = token.value as Sequence
            t[0] = "title"
            extras.add(token.value)
            getToken()
        }
        if (token.value != '{') {
            return invalid("invalid ebnf (missing opening {)")
        }

        while (true) {
            val tokenResult = production()
            if (tokenResult == '}' || tokenResult == -1) {
                break
            }
        }

        getToken()
        if (token.isSequence) {
            val t = token.value as Sequence
            t[0] = "comment"
            extras.add(token.value)
            getToken()
        }
        if (token.value != -1) {
            return invalid("invalid ebnf (missing eof?)")
        }
        if (err) {
            return -1
        }

        val k = ididx.indexOfFirst { it == -1 }
        if (k != -1) {
            return invalid("invalid ebnf (undefined:${idents[k]})")
        }

        pprint(productions, "productions")
        pprint(idents, "idents")
        pprint(ididx, "ididx")
        pprint(extras, "extras")
        return 1
    }

    // Adjusts Kotlin's normal printing to look more like Phix output.
    private fun pprint(ob: Any, header: String) {
        println("\n$header:")
        var pp = ob.toString()
        pp = pp.replace("[", "{")
        pp = pp.replace("]", "}")
        pp = pp.replace(" ", ", ")
        for (i in idents.indices) {
            pp = pp.replace(i.toString(), i.toString())
        }
        println(pp)
    }

    // The rules that applies() has to deal with are:
    // {factors} - if rule[0] is not string,
    // just apply one after the other recursively.
    // {"terminal", "a1"}       -- literal constants
    // {"or", <e1>, <e2>, ...}  -- (any) one of n
    // {"repeat", <e1>}         -- as per "{}" in ebnf
    // {"optional", <e1>}       -- as per "[]" in ebnf
    // {"ident", <name>, idx}   -- apply the sub-rule

    private fun applies(rule: Sequence): Boolean {
        val wasSdx = sdx // in case of failure
        val r1 = rule[0]

        when {
            r1 !is String -> {
                for (i in rule.indices) {
                    if (!applies(rule[i] as Sequence)) {
                        sdx = wasSdx
                        return false
                    }
                }
            }
            r1 == "terminal" -> {
                skipSpaces()
                val r2 = rule[1] as String
                for (i in r2.indices) {
                    if (sdx >= src.length || src[sdx] != r2[i]) {
                        sdx = wasSdx
                        return false
                    }
                    sdx++
                }
            }
            r1 == "or" -> {
                for (i in 1 until rule.size) {
                    if (applies(rule[i] as Sequence)) {
                        return true
                    }
                }
                sdx = wasSdx
                return false
            }
            r1 == "repeat" -> {
                while (applies(rule[1] as Sequence)) {
                    // continue repeating
                }
            }
            r1 == "optional" -> {
                applies(rule[1] as Sequence)
            }
            r1 == "ident" -> {
                val i = rule[2] as Int
                val ii = ididx[i]
                if (!applies(productions[ii][2] as Sequence)) {
                    sdx = wasSdx
                    return false
                }
            }
            else -> throw RuntimeException("invalid rule in applies() function")
        }
        return true
    }

    private fun checkValid(test: String) {
        src = test
        sdx = 0
        var res = applies(productions[0][2] as Sequence)
        skipSpaces()
        if (sdx < src.length) {
            res = false
        }
        println("\"$test\", ${results[1 - res.toInt()]}")
    }

    companion object {
        @JvmStatic
        fun main(args: Array<String>) {
            val parser = MainKt()

            val ebnfs = arrayOf(
                "\"a\" {\n" +
                "    a = \"a1\" ( \"a2\" | \"a3\" ) { \"a4\" } [ \"a5\" ] \"a6\" ;\n" +
                "} \"z\" ",

                "{\n" +
                "    expr = term { plus term } .\n" +
                "    term = factor { times factor } .\n" +
                "    factor = number | '(' expr ')' .\n" +
                " \n" +
                "    plus = \"+\" | \"-\" .\n" +
                "    times = \"*\" | \"/\" .\n" +
                " \n" +
                "    number = digit { digit } .\n" +
                "    digit = \"0\" | \"1\" | \"2\" | \"3\" | \"4\" | \"5\" | \"6\" | \"7\" | \"8\" | \"9\" .\n" +
                "}",

                "a = \"1\"",
                "{ a = \"1\" ;",
                "{ hello world = \"1\"; }",
                "{ foo = bar . }"
            )

            val tests = arrayOf(
                arrayOf(
                    "a1a3a4a4a5a6",
                    "a1 a2a6",
                    "a1 a3 a4 a6",
                    "a1 a4 a5 a6",
                    "a1 a2 a4 a5 a5 a6",
                    "a1 a2 a4 a5 a6 a7",
                    "your ad here"
                ),
                arrayOf(
                    "2",
                    "2*3 + 4/23 - 7",
                    "(3 + 4) * 6-2+(4*(4))",
                    "-2",
                    "3 +",
                    "(4 + 3"
                )
            )

            for (i in ebnfs.indices) {
                if (parser.parse(ebnfs[i]) == 1) {
                    println("\ntests:")
                    if (i < tests.size) {
                        for (test in tests[i]) {
                            parser.checkValid(test)
                        }
                    }
                }
                println()
            }
        }
    }
}
