struct PartialFs {
    f Func @[required]
    fs FuncS @[required]
}

type Func = fn (int) int
type FuncS = fn (Func, []int) []int

fn fs(f Func, seq []int) []int { return seq.map(f) }

fn (p PartialFs) call(seq []int) []int { return p.fs(p.f, seq) }

fn f1(n int) int { return 2 * n }

fn f2(n int) int { return n * n }

fn main() {
    fsf1 := PartialFs{f: f1, fs: fs}
    fsf2 := PartialFs{f: f2, fs: fs}

    seqs := [
        [0, 1, 2, 3],
        [2, 4, 6, 8],
    ]

    for seq in seqs {
        println(fs(f1, seq))
        println(fsf1.call(seq))
        println(fs(f2, seq))
        println(fsf2.call(seq))
        println("")
    }
}
