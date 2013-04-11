package main

import "fmt"

// A wire is modeled as a channel of booleans.
// You can feed it a single value without blocking.
// Reading a value blocks until a value is available.
type Wire chan bool
func MakeWire() Wire {
   return make(Wire,1)
}

// A source for zero values.
func Zero() Wire {
   r := MakeWire()
   go func() {
      for {
         r <- false
      }
   }()
   return r
}

// And gate.
func And(a,b Wire) Wire {
   r := MakeWire()
   go func() {
      for {
         x := <-a
         y := <-b
         r <- (x && y)
      }
   }()
   return r
}

// Or gate.
func Or(a,b Wire) Wire {
   r := MakeWire()
   go func() {
      for {
         x := <-a
         y := <-b
         r <- (x || y)
      }
   }()
   return r
}

// Not gate.
func Not(a Wire) Wire {
   r := MakeWire()
   go func() {
      for {
         x := <-a
         r <- !x
      }
   }()
   return r
}

// Split a wire in two.
func Split(a Wire) (Wire,Wire) {
   r1 := MakeWire()
   r2 := MakeWire()
   go func() {
      for {
         x := <-a
         r1 <- x
         r2 <- x
      }
   }()
   return r1, r2
}

// Xor gate, composed of Or, And and Not gates.
func Xor(a,b Wire) Wire {
   a1,a2 := Split(a)
   b1,b2 := Split(b)
   return Or(And(Not(a1),b1),And(a2,Not(b2)))
}

// A half adder, composed of two splits and an And and Xor gate.
func HalfAdder(a,b Wire) (sum,carry Wire) {
   a1,a2 := Split(a)
   b1,b2 := Split(b)
   carry = And(a1,b1)
   sum = Xor(a2,b2)
   return
}

// A full adder, composed of two half adders, and an Or gate.
func FullAdder(a,b,carryIn Wire) (result,carryOut Wire) {
   s1,c1 := HalfAdder(carryIn,a)
   result,c2 := HalfAdder(b,s1)
   carryOut = Or(c1,c2)
   return
}

// A four bit adder, composed of a zero source, and four full adders.
func FourBitAdder(a1,a2,a3,a4 Wire, b1,b2,b3,b4 Wire) (r1,r2,r3,r4 Wire, carry Wire) {
   carry = Zero()
   r1,carry = FullAdder(a1,b1,carry)
   r2,carry = FullAdder(a2,b2,carry)
   r3,carry = FullAdder(a3,b3,carry)
   r4,carry = FullAdder(a4,b4,carry)
   return
}

func main() {
   // Create wires
   a1 := MakeWire()
   a2 := MakeWire()
   a3 := MakeWire()
   a4 := MakeWire()
   b1 := MakeWire()
   b2 := MakeWire()
   b3 := MakeWire()
   b4 := MakeWire()
   // Construct circuit
   r1,r2,r3,r4, carry := FourBitAdder(a1,a2,a3,a4, b1,b2,b3,b4)
   // Feed it some values
   a4 <- false; a3 <- false; a2 <- true; a1 <- false // 0010
   b4 <- true;  b3 <- true;  b2 <- true; b1 <- false // 1110
   B := map[bool]int { false: 0, true: 1 }
   // Read the result
   fmt.Printf("0010 + 1110 = %d%d%d%d (carry = %d)\n",
      B[<-r4],B[<-r3],B[<-r2],B[<-r1], B[<-carry])
}
