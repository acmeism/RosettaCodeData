// SB implements the Stern-Brocot sequence.
//
// Generator() satisfies RC Task 1.  For remaining tasks, Generator could be
// used but FirstN(), and Find() are simpler methods for specific stopping
// criteria.  FirstN and Find might also be considered to satisfy Task 1,
// in which case Generator would not really be needed.  Anyway, there it is.
package sb

// Seq represents an even number of terms of a Stern-Brocot sequence.
//
// Terms are stored in a slice.  Terms start with 1.
// (Specifically, the zeroth term, 0, given in OEIS A002487 is not represented.)
// Term 1 (== 1) is stored at slice index 0.
//
// Methods on Seq rely on Seq always containing an even number of terms.
type Seq []int

// New returns a Seq with the two base terms.
func New() *Seq {
    return &Seq{1, 1} // Step 1 of the RC task.
}

// TwoMore appends two more terms to p.
// It's the body of the loop in the RC algorithm.
// Generate(), FirstN(), and Find() wrap this body in different ways.
func (p *Seq) TwoMore() {
    s := *p
    n := len(s) / 2 // Steps 2 and 5 of the RC task.
    c := s[n]
    *p = append(s, c+s[n-1], c) // Steps 3 and 4 of the RC task.
}

// Generator returns a generator function that returns successive terms
// (until overflow.)
func Generator() func() int {
    n := 0
    p := New()
    return func() int {
        if len(*p) == n {
            p.TwoMore()
        }
        t := (*p)[n]
        n++
        return t
    }
}

// FirstN lazily extends p as needed so that it has at least n terms.
// FirstN then returns a list of the first n terms.
func (p *Seq) FirstN(n int) []int {
    for len(*p) < n {
        p.TwoMore()
    }
    return []int((*p)[:n])
}

// Find lazily extends p as needed until it contains the value x
// Find then returns the slice index of x in p.
func (p *Seq) Find(x int) int {
    for n, f := range *p {
        if f == x {
            return n
        }
    }
    for {
        p.TwoMore()
        switch x {
        case (*p)[len(*p)-2]:
            return len(*p) - 2
        case (*p)[len(*p)-1]:
            return len(*p) - 1
        }
    }
}
