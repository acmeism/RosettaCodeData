import java.io.File
import java.util.*

internal object Interpreter {
    private val globals = mutableMapOf<String, Int>()
    private lateinit var s: Scanner
    private val strToNodes = NodeType.entries.associateBy(NodeType::value)

    private fun str(s: String): String = buildString {
        var i = 0
        val s = s.replace("\"", "")
        while (i < s.length) {
            if (s[i] == '\\' && i + 1 < s.length) {
                if (s[i + 1] == 'n') {
                    append('\n')
                    i += 2
                } else if (s[i] == '\\') {
                    append('\\')
                    i += 2
                }
            } else {
                append(s[i])
                i++
            }
        }
    }

    private fun itob(i: Int): Boolean = i != 0
    private fun btoi(b: Boolean): Int = if (b) 1 else 0

    private fun fetchVar(name: String): Int = globals.computeIfAbsent(name) { 0 }

    @Throws(Exception::class)
    fun interpret(n: Node?): Int = when (n?.nt) {
        null -> 0
        NodeType.Integer -> n.value!!.toInt()
        NodeType.Ident -> fetchVar(n.value!!)
        NodeType.String -> n.value!!.toInt()
        NodeType.Assign -> {
            globals[n.left!!.value!!] = interpret(n.right)
            0
        }

        NodeType.Add -> interpret(n.left) + interpret(n.right)
        NodeType.Sub -> interpret(n.left) - interpret(n.right)
        NodeType.Mul -> interpret(n.left) * interpret(n.right)
        NodeType.Div -> interpret(n.left) / interpret(n.right)
        NodeType.Mod -> interpret(n.left) % interpret(n.right)
        NodeType.Lss -> btoi(interpret(n.left) < interpret(n.right))
        NodeType.Leq -> btoi(interpret(n.left) <= interpret(n.right))
        NodeType.Gtr -> btoi(interpret(n.left) > interpret(n.right))
        NodeType.Geq -> btoi(interpret(n.left) >= interpret(n.right))
        NodeType.Eql -> btoi(interpret(n.left) == interpret(n.right))
        NodeType.Neq -> btoi(interpret(n.left) != interpret(n.right))
        NodeType.And -> btoi(itob(interpret(n.left)) && itob(interpret(n.right)))
        NodeType.Or -> btoi(itob(interpret(n.left)) || itob(interpret(n.right)))
        NodeType.Not -> if (interpret(n.left) == 0) 1 else 0

        NodeType.Negate -> -interpret(n.left)
        NodeType.If -> {
            if (interpret(n.left) != 0) interpret(n.right!!.left) else interpret(n.right!!.right)
            0
        }

        NodeType.While -> {
            while (interpret(n.left) != 0) {
                interpret(n.right)
            }
            0
        }

        NodeType.Prtc -> {
            print(interpret(n.left).toChar().toString())
            0
        }

        NodeType.Prti -> {
            print(interpret(n.left).toString())
            0
        }

        NodeType.Prts -> {
            print(str(n.left!!.value!!)) //interpret(n.left));
            0
        }

        NodeType.Sequence -> {
            interpret(n.left)
            interpret(n.right)
            0
        }

        else -> throw Exception("Error: '${n.nt}' found, expecting operator")
    }

    private fun loadAst(): Node? {

        while (s.hasNext()) {
            val line = s.nextLine()

            val (command, value) = if (line.length > 15) {
                line.substring(0, 15).trim { it <= ' ' } to line.substring(15).trim { it <= ' ' }
            } else {
                line.trim { it <= ' ' } to null
            }
            if (command == ";") return null

            if (value != null) return Node.makeLeaf(strToNodes.getValue(command), value)

            return Node.makeNode(
                nodeType = strToNodes[command] ?: throw Exception("Command not found: '$command'"),
                left = loadAst(),
                right = loadAst(),
            )
        }
        return null // for the compiler, not needed
    }

    @JvmStatic
    fun main(args: Array<String>) {
        if (args.isNotEmpty()) {
            try {
                s = Scanner(File(args[0]))
                val n = loadAst()
                interpret(n)
            } catch (e: Exception) {
                println("Ex: " + e.message)
            }
        }
    }

    internal class Node(
        val nt: NodeType,
        var left: Node? = null,
        var right: Node? = null,
        var value: String? = null,
    ) {
        companion object {
            fun makeNode(nodeType: NodeType, left: Node?, right: Node?): Node = Node(nodeType, left, right, "")
            fun makeLeaf(nodeType: NodeType, value: String?): Node = Node(nodeType, null, null, value)
        }
    }

    internal enum class NodeType(val value: String) {
        None(";"), Ident("Identifier"), String("String"), Integer("Integer"),
        Sequence("Sequence"), If("If"),
        Prtc("Prtc"), Prts("Prts"), Prti("Prti"), While("While"),
        Assign("Assign"), Negate("Negate"), Not("Not"), Mul("Multiply"), Div("Divide"),
        Mod("Mod"), Add("Add"),
        Sub("Subtract"), Lss("Less"), Leq("LessEqual"),
        Gtr("Greater"), Geq("GreaterEqual"), Eql("Equal"), Neq("NotEqual"), And("And"), Or("Or");

        override fun toString() = value
    }
}
