import strings

struct Sandpile {
mut:
    a [9]int
}

const (
neighbors = [
    [1, 3], [0, 2, 4], [1, 5], [0, 4, 6], [1, 3, 5, 7], [2, 4, 8], [3, 7], [4, 6, 8], [5, 7]
]
)

// 'a' is in row order
fn new_sandpile(a [9]int) Sandpile { return Sandpile{a} }

fn (s &Sandpile) plus(other &Sandpile) Sandpile {
    mut b := [9]int{}
    for i in 0..9 {
        b[i] = s.a[i] + other.a[i]
    }
    return Sandpile{b}
}

fn (s &Sandpile) is_stable() bool {
    for e in s.a {
        if e > 3 {
            return false
        }
    }
    return true
}

// just topples once so we can observe intermediate results
fn (mut s Sandpile) topple() {
    for i in 0..9 {
        if s.a[i] > 3 {
            s.a[i] -= 4
            for j in neighbors[i] {
                s.a[j]++
            }
            return
        }
    }
}

fn (s Sandpile) str() string {
    mut sb := strings.new_builder(64)
    for i in 0..3 {
        for j in 0..3 {
            sb.write_string("${u8(s.a[3*i+j])} ")
        }
        sb.write_string("\n")
    }
    return sb.str()
}

fn main() {
    println("Avalanche of topplings:\n")
    mut s4 := new_sandpile([4, 3, 3, 3, 1, 2, 0, 2, 3]!)
    println(s4)
    for !s4.is_stable() {
        s4.topple()
        println(s4)
    }

    println("Commutative additions:\n")
    s1 := new_sandpile([1, 2, 0, 2, 1, 1, 0, 1, 3]!)
    s2 := new_sandpile([2, 1, 3, 1, 0, 1, 0, 1, 0]!)
    mut s3_a := s1.plus(s2)
    for !s3_a.is_stable() {
        s3_a.topple()
    }
    mut s3_b := s2.plus(s1)
    for !s3_b.is_stable() {
        s3_b.topple()
    }
    println("$s1\nplus\n\n$s2\nequals\n\n$s3_a")
    println("and\n\n$s2\nplus\n\n$s1\nalso equals\n\n$s3_b")

    println("Addition of identity sandpile:\n")
    s3 := new_sandpile([3, 3, 3, 3, 3, 3, 3, 3, 3]!)
    s3_id := new_sandpile([2, 1, 2, 1, 0, 1, 2, 1, 2]!)
    s4 = s3.plus(s3_id)
    for !s4.is_stable() {
        s4.topple()
    }
    println("$s3\nplus\n\n$s3_id\nequals\n\n$s4")

    println("Addition of identities:\n")
    mut s5 := s3_id.plus(s3_id)
    for !s5.is_stable() {
        s5.topple()
    }
    print("$s3_id\nplus\n\n$s3_id\nequals\n\n$s5")
}
