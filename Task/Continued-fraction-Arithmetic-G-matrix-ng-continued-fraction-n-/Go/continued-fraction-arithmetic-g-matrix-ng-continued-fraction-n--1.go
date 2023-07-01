package cf

// A 2×2 matix:
//     [ a₁   a ]
//     [ b₁   b ]
//
// which when "applied" to a continued fraction representing x
// gives a new continued fraction z such that:
//
//         a₁ * x + a
//     z = ----------
//         b₁ * x + b
//
// Examples:
//      NG4{0, 1, 0, 4}.ApplyTo(x) gives 0*x + 1/4 -> 1/4 = [0; 4]
//      NG4{0, 1, 1, 0}.ApplyTo(x) gives 1/x
//      NG4{1, 1, 0, 2}.ApplyTo(x) gives (x+1)/2
//
// Note that several operations (e.g. addition and division)
// can be efficiently done with a single matrix application.
// However, each matrix application may require
// several calculations for each outputed term.
type NG4 struct {
	A1, A int64
	B1, B int64
}

func (ng NG4) needsIngest() bool {
	if ng.isDone() {
		panic("b₁==b==0")
	}
	return ng.B1 == 0 || ng.B == 0 || ng.A1/ng.B1 != ng.A/ng.B
}

func (ng NG4) isDone() bool {
	return ng.B1 == 0 && ng.B == 0
}

func (ng *NG4) ingest(t int64) {
	// [ a₁   a ] becomes [ a + a₁×t   a₁ ]
	// [ b₁   b ]         [ b + b₁×t   b₁ ]
	ng.A1, ng.A, ng.B1, ng.B =
		ng.A+ng.A1*t, ng.A1,
		ng.B+ng.B1*t, ng.B1
}

func (ng *NG4) ingestInfinite() {
	// [ a₁   a ] becomes [ a₁   a₁ ]
	// [ b₁   b ]         [ b₁   b₁ ]
	ng.A, ng.B = ng.A1, ng.B1
}

func (ng *NG4) egest(t int64) {
	// [ a₁   a ] becomes [      b₁         b   ]
	// [ b₁   b ]         [ a₁ - b₁×t   a - b×t ]
	ng.A1, ng.A, ng.B1, ng.B =
		ng.B1, ng.B,
		ng.A1-ng.B1*t, ng.A-ng.B*t
}

// ApplyTo "applies" the matrix `ng` to the continued fraction `cf`,
// returning the resulting continued fraction.
func (ng NG4) ApplyTo(cf ContinuedFraction) ContinuedFraction {
	return func() NextFn {
		next := cf()
		done := false
		return func() (int64, bool) {
			if done {
				return 0, false
			}
			for ng.needsIngest() {
				if t, ok := next(); ok {
					ng.ingest(t)
				} else {
					ng.ingestInfinite()
				}
			}
			t := ng.A1 / ng.B1
			ng.egest(t)
			done = ng.isDone()
			return t, true
		}
	}
}
