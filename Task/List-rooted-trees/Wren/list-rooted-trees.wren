import "./long" for ULong
import "os" for Process

var treeList = []
var offset = List.filled(32, 0)
offset[1] = 1

var append = Fn.new { |t|
    treeList.add(ULong.one | (t << 1))
}

var show = Fn.new { |t, len|
    while (len > 0) {
        len = len - 1
        System.write(t.isOdd ? "(" : ")")
        t = t >> 1
    }
}

var listTrees = Fn.new { |n|
    for (i in offset[n]...offset[n+1]) {
        show.call(treeList[i], n * 2)
        System.print()
    }
}

/* assemble tree from subtrees
	n:   length of tree we want to make
	t:   assembled parts so far
	sl:  length of subtree we are looking at
	pos: offset of subtree we are looking at
	rem: remaining length to be put together
*/

var assemble // recursive
assemble = Fn.new { |n, t, sl, pos, rem|
    if (rem == 0) {
        append.call(t)
        return
    }
    if (sl > rem) { // need smaller subtrees
        pos = offset[sl = rem]
    } else if (pos >= offset[sl + 1]) {
        // used up sl-trees, try smaller ones
        sl = sl - 1
        if (sl == 0) return
        pos = offset[sl]
    }
    assemble.call(n, (t << (2 * sl)) | treeList[pos], sl, pos, rem - sl)
    assemble.call(n, t, sl, pos + 1, rem)
}

var makeTrees // recursive
makeTrees = Fn.new { |n|
    if (offset[n + 1] != 0) return
    if (n > 0) makeTrees.call(n - 1)
    assemble.call(n, ULong.zero, n - 1, offset[n - 1], n - 1)
    offset[n + 1] = treeList.count
}

var args = Process.arguments
if (args.count != 1) Fiber.abort("There must be exactly 1 command line argument.")
var n = Num.fromString(args[0])
if (!n) Fiber.abort("Argument is not a valid number.")
if (n < 1 || n > 12) Fiber.abort("Argument must be between 1 and 12.")

// init 1-tree
append.call(ULong.zero)
makeTrees.call(n)
System.print("Number of %(n)-trees: %(offset[n + 1] - offset[n])")
listTrees.call(n)
