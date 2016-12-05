package main

import (
   "fmt"
   "math"
   "math/big"
   "sort"
   "time"
)

type logrep struct {
   lg         float64
   x2, x3, x5 uint32
}
type logreps []logrep
func (s logreps) Len() int { // necessary methods for sorting
   return len(s)
}
func (s logreps) Swap(i, j int) {
   s[i], s[j] = s[j], s[i]
}
func (s logreps) Less(i, j int) bool {
   return s[j].lg < s[i].lg // sort in decreasing order (reverse order compare)
}

func nthHamming(n uint64) (uint32, uint32, uint32) {
   if n < 2 {
      if n < 1 {
         panic("nthHamming:  argument is zero!")
      }
      return 0, 0, 0
   }
   const lb3 = 1.5849625007211561814537389439478 // math.Log2(3.0)
   const lb5 = 2.3219280948873623478703194294894 // math.Log2(5.0)
   fctr := 6.0 * lb3 * lb5
   crctn := math.Log2(math.Sqrt(30.0)) // from WP formula
   lgest := math.Pow(fctr*float64(n), 1.0/3.0) - crctn
   var frctn float64
   if n < 1000000000 {
      frctn = 0.509
   } else {
      frctn = 0.106
   }
   lghi := math.Pow(fctr*(float64(n)+frctn*lgest), 1.0/3.0) - crctn
   lglo := 2.0*lgest - lghi // and a lower limit of the upper "band"
   var count uint64 = 0
   bnd := make(logreps, 0) // give it one value so doubling size works
   klmt := uint32(lghi/lb5) + 1
   for k := uint32(0); k < klmt; k++ {
      p := float64(k) * lb5
      jlmt := uint32((lghi-p)/lb3) + 1
      for j := uint32(0); j < jlmt; j++ {
         q := p + float64(j)*lb3
         ir := lghi - q
         lg := q + math.Floor(ir) // current log value estimated
         count += uint64(ir) + 1
         if lg >= lglo {
            bnd = append(bnd, logrep{lg, uint32(ir), j, k})
         }
      }
   }
   if n > count {
      panic("nthHamming:  band high estimate is too low!")
   }
   ndx := int(count - n)
   if ndx >= bnd.Len() {
      panic("nthHamming:  band low estimate is too high!")
   }
   sort.Sort(bnd) // sort decreasing order due definition of Less above

   rslt := bnd[ndx]
   return rslt.x2, rslt.x3, rslt.x5
}

func convertTpl2BigInt(x2, x3, x5 uint32) *big.Int {
   result := big.NewInt(1)
   two := big.NewInt(2)
   three := big.NewInt(3)
   five := big.NewInt(5)
   for i := uint32(0); i < x2; i++ {
      result.Mul(result, two)
   }
   for i := uint32(0); i < x3; i++ {
      result.Mul(result, three)
   }
   for i := uint32(0); i < x5; i++ {
      result.Mul(result, five)
   }
   return result
}

func main() {
   for i := 1; i <= 20; i++ {
      fmt.Printf("%v ", convertTpl2BigInt(nthHamming(uint64(i))))
   }
   fmt.Println()
   fmt.Println(convertTpl2BigInt(nthHamming(1691)))

   strt := time.Now()
   x2, x3, x5 := nthHamming(uint64(1e6))
   end := time.Now()

   fmt.Printf("2^%v times 3^%v times 5^%v\r\n", x2, x3, x5)
   lrslt := convertTpl2BigInt(x2, x3, x5)
   lgrslt := (float64(x2) + math.Log2(3.0)*float64(x3) +
               math.Log2(5.0)*float64(x5)) * math.Log10(2.0)
   exp := math.Floor(lgrslt)
   mant := math.Pow(10.0, lgrslt-exp)
   fmt.Printf("Approximately:  %vE+%v\r\n", mant, exp)
   rs := lrslt.String()
   lrs := len(rs)
   fmt.Printf("%v digits:\r\n", lrs)
   if lrs <= 10000 {
      ndx := 0
      for ; ndx < lrs-100; ndx += 100 {
         fmt.Println(rs[ndx : ndx+100])
      }
      fmt.Println(rs[ndx:])
   }

   fmt.Printf("This last found the %vth hamming number in %v.\r\n", n, end.Sub(strt))
}
