package main

import "fmt"

type Value float64
type Matrix [][]Value

func Multiply(m1, m2 Matrix) (m3 Matrix, ok bool) {
   rows, cols, extra := len(m1), len(m2[0]), len(m2)
   if len(m1[0]) != extra { return nil, false }
   m3 = make(Matrix, rows)
   for i := 0; i < rows; i++ {
      m3[i] = make([]Value,cols)
      for j := 0; j < cols; j++ {
         for k := 0; k < extra; k++ {
            m3[i][j] += m1[i][k] * m2[k][j]
         }
      }
   }
   return m3, true
}

func (m Matrix) String() string {
   rows := len(m)
   cols := len(m[0])
   out := "["
   for r := 0; r < rows; r++ {
      if r > 0 { out += ",\n " }
      out += "[ "
      for c := 0; c < cols; c++ {
         if c > 0 { out += ", " }
         out += fmt.Sprintf("%7.3f", m[r][c])
      }
      out += " ]"
   }
   out += "]"
   return out
}

func main() {
   A := Matrix{[]Value{1,  1,  1,   1},
               []Value{2,  4,  8,  16},
               []Value{3,  9, 27,  81},
               []Value{4, 16, 64, 256}}
   B := Matrix{[]Value{  4.0  , -3.0  ,  4.0/3, -1.0/4 },
               []Value{-13.0/3, 19.0/4, -7.0/3, 11.0/24},
               []Value{  3.0/2, -2.0  ,  7.0/6, -1.0/4 },
               []Value{ -1.0/6,  1.0/4, -1.0/6,  1.0/24}}
   P,ok := Multiply(A,B)
   if !ok { panic("Invalid dimensions") }
   fmt.Printf("Matrix A:\n%s\n\n", A)
   fmt.Printf("Matrix B:\n%s\n\n", B)
   fmt.Printf("Product of A and B:\n%s\n\n", P)
}
