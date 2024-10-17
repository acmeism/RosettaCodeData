// version 1.1.3

typealias Tree = Long

val treeList = mutableListOf<Tree>()
val offset = IntArray(32) { if (it == 1) 1 else 0 }

fun append(t: Tree) {
    treeList.add(1L or (t shl 1))
}

fun show(t: Tree, l: Int) {
    var tt = t
    var ll = l
    while (ll-- > 0) {
        print(if (tt % 2L == 1L) "(" else ")")
        tt = tt ushr 1
    }
}

fun listTrees(n: Int) {
    for (i in offset[n] until offset[n + 1]) {
        show(treeList[i], n * 2)
        println()
    }
}

/* assemble tree from subtrees
	n:   length of tree we want to make
	t:   assembled parts so far
	sl:  length of subtree we are looking at
	pos: offset of subtree we are looking at
	rem: remaining length to be put together
*/

fun assemble(n: Int, t: Tree, sl: Int, pos: Int, rem: Int) {
    if (rem == 0) {
        append(t)
        return
    }

    var pp = pos
    var ss = sl

    if (sl > rem) { // need smaller subtrees
        ss = rem
        pp = offset[ss]
    }
    else if (pp >= offset[ss + 1]) {
        // used up sl-trees, try smaller ones
        ss--
        if(ss == 0) return
        pp = offset[ss]
    }

    assemble(n, (t shl (2 * ss)) or treeList[pp], ss, pp, rem - ss)
    assemble(n, t, ss, pp + 1, rem)
}

fun makeTrees(n: Int) {
    if (offset[n + 1] != 0) return
    if (n > 0) makeTrees(n - 1)
    assemble(n, 0, n - 1, offset[n - 1], n - 1)
    offset[n + 1] = treeList.size
}

fun main(args: Array<String>) {
    if (args.size != 1) {
        throw IllegalArgumentException("There must be exactly 1 command line argument")
    }
    val n = args[0].toIntOrNull()
    if (n == null) throw IllegalArgumentException("Argument is not a valid number")
    // n limited to 12 to avoid overflowing default stack
    if (n !in 1..12) throw IllegalArgumentException("Argument must be between 1 and 12")

    // init 1-tree
    append(0)

    makeTrees(n)
    println("Number of $n-trees: ${offset[n + 1] - offset[n]}")
    listTrees(n)
}
