package cf

import "math"

// A 2×4 matix:
//     [ a₁₂   a₁   a₂   a ]
//     [ b₁₂   b₁   b₂   b ]
//
// which when "applied" to two continued fractions N1 and N2
// gives a new continued fraction z such that:
//
//         a₁₂ * N1 * N2  +  a₁ * N1  +  a₂ * N2  +  a
//     z = -------------------------------------------
//         b₁₂ * N1 * N2  +  b₁ * N1  +  b₂ * N2  +  b
//
// Examples:
//      NG8{0,1,1,0,  0,0,0,1} gives N1 + N2
//      NG8{0,1,-1,0, 0,0,0,1} gives N1 - N2
//      NG8{1,0,0,0,  0,0,0,1} gives N1 * N2
//      NG8{0,1,0,0,  0,0,1,0} gives N1 / N2
//      NG8{21,-15,28,-20, 0,0,0,1} gives 21*N1*N2 -15*N1 +28*N2 -20
//                               which is (3*N1 + 4) * (7*N2 - 5)
type NG8 struct {
	A12, A1, A2, A int64
	B12, B1, B2, B int64
}

// Basic identities as NG8 matrices.
var (
	NG8Add = NG8{0, 1, 1, 0, 0, 0, 0, 1}
	NG8Sub = NG8{0, 1, -1, 0, 0, 0, 0, 1}
	NG8Mul = NG8{1, 0, 0, 0, 0, 0, 0, 1}
	NG8Div = NG8{0, 1, 0, 0, 0, 0, 1, 0}
)

func (ng *NG8) needsIngest() bool {
	if ng.B12 == 0 || ng.B1 == 0 || ng.B2 == 0 || ng.B == 0 {
		return true
	}
	x := ng.A / ng.B
	return ng.A1/ng.B1 != x || ng.A2/ng.B2 != x && ng.A12/ng.B12 != x
}

func (ng *NG8) isDone() bool {
	return ng.B12 == 0 && ng.B1 == 0 && ng.B2 == 0 && ng.B == 0
}

func (ng *NG8) ingestWhich() bool { // true for N1, false for N2
	if ng.B == 0 && ng.B2 == 0 {
		return true
	}
	if ng.B == 0 || ng.B2 == 0 {
		return false
	}
	x1 := float64(ng.A1) / float64(ng.B1)
	x2 := float64(ng.A2) / float64(ng.B2)
	x := float64(ng.A) / float64(ng.B)
	return math.Abs(x1-x) > math.Abs(x2-x)
}

func (ng *NG8) ingest(isN1 bool, t int64) {
	if isN1 {
		// [ a₁₂   a₁   a₂   a ] becomes [ a₂+a₁₂*t  a+a₁*t  a₁₂  a₁]
		// [ b₁₂   b₁   b₂   b ]         [ b₂+b₁₂*t  b+b₁*t  b₁₂  b₁]
		ng.A12, ng.A1, ng.A2, ng.A,
			ng.B12, ng.B1, ng.B2, ng.B =
			ng.A2+ng.A12*t, ng.A+ng.A1*t, ng.A12, ng.A1,
			ng.B2+ng.B12*t, ng.B+ng.B1*t, ng.B12, ng.B1
	} else {
		// [ a₁₂   a₁   a₂   a ] becomes [ a₁+a₁₂*t  a₁₂  a+a₂*t  a₂]
		// [ b₁₂   b₁   b₂   b ]         [ b₁+b₁₂*t  b₁₂  b+b₂*t  b₂]
		ng.A12, ng.A1, ng.A2, ng.A,
			ng.B12, ng.B1, ng.B2, ng.B =
			ng.A1+ng.A12*t, ng.A12, ng.A+ng.A2*t, ng.A2,
			ng.B1+ng.B12*t, ng.B12, ng.B+ng.B2*t, ng.B2
	}
}

func (ng *NG8) ingestInfinite(isN1 bool) {
	if isN1 {
		// [ a₁₂   a₁   a₂   a ] becomes [ a₁₂  a₁  a₁₂  a₁ ]
		// [ b₁₂   b₁   b₂   b ]         [ b₁₂  b₁  b₁₂  b₁ ]
		ng.A2, ng.A, ng.B2, ng.B =
			ng.A12, ng.A1,
			ng.B12, ng.B1
	} else {
		// [ a₁₂   a₁   a₂   a ] becomes [ a₁₂  a₁₂  a₂  a₂ ]
		// [ b₁₂   b₁   b₂   b ]         [ b₁₂  b₁₂  b₂  b₂ ]
		ng.A1, ng.A, ng.B1, ng.B =
			ng.A12, ng.A2,
			ng.B12, ng.B2
	}
}

func (ng *NG8) egest(t int64) {
	// [ a₁₂   a₁   a₂   a ] becomes [     b₁₂       b₁       b₂      b   ]
	// [ b₁₂   b₁   b₂   b ]         [ a₁₂-b₁₂*t  a₁-b₁*t  a₂-b₂*t  a-b*t ]
	ng.A12, ng.A1, ng.A2, ng.A,
		ng.B12, ng.B1, ng.B2, ng.B =
		ng.B12, ng.B1, ng.B2, ng.B,
		ng.A12-ng.B12*t, ng.A1-ng.B1*t, ng.A2-ng.B2*t, ng.A-ng.B*t
}

// ApplyTo "applies" the matrix `ng` to the continued fractions
// `N1` and `N2`, returning the resulting continued fraction.
// After ingesting `limit` terms without any output terms the resulting
// continued fraction is terminated.
func (ng NG8) ApplyTo(N1, N2 ContinuedFraction, limit int) ContinuedFraction {
	return func() NextFn {
		next1, next2 := N1(), N2()
		done := false
		sinceEgest := 0
		return func() (int64, bool) {
			if done {
				return 0, false
			}
			for ng.needsIngest() {
				sinceEgest++
				if sinceEgest > limit {
					done = true
					return 0, false
				}
				isN1 := ng.ingestWhich()
				next := next2
				if isN1 {
					next = next1
				}
				if t, ok := next(); ok {
					ng.ingest(isN1, t)
				} else {
					ng.ingestInfinite(isN1)
				}
			}
			sinceEgest = 0
			t := ng.A / ng.B
			ng.egest(t)
			done = ng.isDone()
			return t, true
		}
	}
}
