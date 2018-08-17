package cf

import "fmt"

// A Rat represents a quotient N/D.
type Rat struct {
	N, D int64
}

// String implements fmt.Stringer and returns a string
// representation of `r` in the form "N/D" (even if D == 1).
func (r Rat) String() string {
	return fmt.Sprintf("%d/%d", r.N, r.D)
}

// As ContinuedFraction returns a contined fraction representation of `r`.
func (r Rat) AsContinuedFraction() ContinuedFraction { return r.CFTerms }
func (r Rat) CFTerms() NextFn {
	return func() (int64, bool) {
		if r.D == 0 {
			return 0, false
		}
		q := r.N / r.D
		r.N, r.D = r.D, r.N-q*r.D
		return q, true
	}
}

// Rosetta Code task explicitly asked for this function,
// so here it is. We'll just use the types above instead.
func r2cf(n1, n2 int64) ContinuedFraction { return Rat{n1, n2}.CFTerms }
