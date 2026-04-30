interface IntCollection {
    map_elements(fn (int))
}

struct BinaryTree {
    left  bool
    right bool
}

fn (t &BinaryTree) map_elements(visit fn (int)) {
    if t.left == t.right {
        visit(3)
        visit(1)
        visit(4)
    }
}

struct BTree {
    buckets int
}

fn (t &BTree) map_elements(visit fn (int)) {
    if t.buckets >= 0 {
        visit(1)
        visit(5)
        visit(9)
    }
}

struct Accumulator {
    mut:
    sum   int
    count int
}

fn average(cal IntCollection) f64 {
	mut acc := &Accumulator{}
    acc.sum, acc.count = 0, 0
    cal.map_elements(fn [mut acc] (n int) {
        acc.sum += n
        acc.count++
    })
    return f64(acc.sum) / f64(acc.count)
}

fn main() {
    t1 := &BinaryTree{}
    t2 := &BTree{}
    a1 := average(t1)
    a2 := average(t2)
    println('binary tree average: ${a1}')
    println('b-tree average: ${a2}')
}
