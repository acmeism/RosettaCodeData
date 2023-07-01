import "math/big"

func Root(a *big.Float, n uint64) *big.Float {
	limit := Exp(New(2), 256)
	n1 := n-1
	n1f, rn := New(float64(n1)), Div(New(1.0), New(float64(n)))
	x, x0 := New(1.0), Zero()
	_ = x0
	for {
		potx, t2 := Div(New(1.0), x), a
		for b:=n1; b>0; b>>=1 {
			if b&1 == 1 {
				t2 = Mul(t2, potx)
			}
			potx = Mul(potx, potx)
		}
		x0, x = x, Mul(rn, Add(Mul(n1f, x), t2) )
		if Lesser(Mul(Abs(Sub(x, x0)), limit), x) { break }
	}
	return x
}

func Abs(a *big.Float) *big.Float {
	return Zero().Abs(a)
}

func Exp(a *big.Float, e uint64) *big.Float {
	result := Zero().Copy(a)
	for i:=uint64(0); i<e-1; i++ {
		result = Mul(result, a)
	}
	return result
}

func New(f float64) *big.Float {
	r := big.NewFloat(f)
	r.SetPrec(256)
	return r
}

func Div(a, b *big.Float) *big.Float {
	return Zero().Quo(a, b)
}

func Zero() *big.Float {
	r := big.NewFloat(0.0)
	r.SetPrec(256)
	return r
}

func Mul(a, b *big.Float) *big.Float {
	return Zero().Mul(a, b)
}

func Add(a, b *big.Float) *big.Float {
	return Zero().Add(a, b)
}

func Sub(a, b *big.Float) *big.Float {
	return Zero().Sub(a, b)
}

func Lesser(x, y *big.Float) bool {
	return x.Cmp(y) == -1
}
