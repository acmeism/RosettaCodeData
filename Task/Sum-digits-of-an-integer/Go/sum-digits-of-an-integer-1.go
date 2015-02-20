// File digit.go

package digit

import (
	"math/big"
	"strconv"
)

func SumString(n string, base int) (int, error) {
	i, ok := new(big.Int).SetString(n, base)
	if !ok {
		return 0, strconv.ErrSyntax
	}
	if i.Sign() < 0 {
		return 0, strconv.ErrRange
	}
	if i.BitLen() <= 64 {
		return Sum(i.Uint64(), base), nil
	}
	return SumBig(i, base), nil
}

func Sum(i uint64, base int) (sum int) {
	b64 := uint64(base)
	for ; i > 0; i /= b64 {
		sum += int(i % b64)
	}
	return
}

func SumBig(n *big.Int, base int) (sum int) {
	i := new(big.Int).Set(n)
	b := new(big.Int).SetUint64(uint64(base))
	r := new(big.Int)
	for i.BitLen() > 0 {
		i.DivMod(i, b, r)
		sum += int(r.Uint64())
	}
	return
}
