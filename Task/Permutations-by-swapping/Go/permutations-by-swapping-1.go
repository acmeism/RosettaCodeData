package permute

// Iter takes a slice p and returns an iterator function.  The iterator
// permutes p in place and returns the sign.  After all permutations have
// been generated, the iterator returns 0 and p is left in its initial order.
func Iter(p []int) func() int {
    f := pf(len(p))
    return func() int {
        return f(p)
    }
}

// Recursive function used by perm, returns a chain of closures that
// implement a loopless recursive SJT.
func pf(n int) func([]int) int {
    sign := 1
    switch n {
    case 0, 1:
        return func([]int) (s int) {
            s = sign
            sign = 0
            return
        }
    default:
        p0 := pf(n - 1)
        i := n
        var d int
        return func(p []int) int {
            switch {
            case sign == 0:
            case i == n:
                i--
                sign = p0(p[:i])
                d = -1
            case i == 0:
                i++
                sign *= p0(p[1:])
                d = 1
                if sign == 0 {
                    p[0], p[1] = p[1], p[0]
                }
            default:
                p[i], p[i-1] = p[i-1], p[i]
                sign = -sign
                i += d
            }
            return sign
        }
    }
}
