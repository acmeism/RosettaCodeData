struct Seq {
    start int
    stop int
    incr int
    comment string
}

const examples = [
    Seq{-2, 2, 1, "Normal"},
    Seq{-2, 2, 0, "Zero increment"},
    Seq{-2, 2, -1, "Increments away from stop value"},
    Seq{-2, 2, 10, "First increment is beyond stop value"},
    Seq{2, -2, 1, "Start more than stop: positive increment"},
    Seq{2, 2, 1, "Start equal stop: positive increment"},
    Seq{2, 2, -1, "Start equal stop: negative increment"},
    Seq{2, 2, 0, "Start equal stop: zero increment"},
    Seq{0, 0, 0, "Start equal stop equal zero: zero increment"},
]

fn sequence(s Seq, limit int) []int {
    mut seq := []int{}
    for i, c := s.start, 0; i <= s.stop && c < limit; i, c = i+s.incr, c+1 {
        seq << i
    }
    return seq
}

fn main() {
    limit := 10
    for ex in examples {
        println(ex.comment)
        print("Range($ex.start, $ex.stop, $ex.incr) -> ")
        println(sequence(ex, limit))
        println('')
    }
}
