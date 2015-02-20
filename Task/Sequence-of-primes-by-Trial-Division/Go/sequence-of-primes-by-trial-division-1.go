package main

import "fmt"

func NumsFromBy(from int, by int, ch chan<- int) {
  for i := from; ; i+=by {
    ch <- i
  }
}

func Filter(in <-chan int, out chan<- int, prime int) {
  for {
    i := <-in
    if i%prime != 0 {            // here is the trial division
      out <- i
    }
  }
}

func Sieve(out chan<- int) {
  out <- 2
  out <- 3
  q := 9
  ps := make(chan int)
  go Sieve(ps)                   // separate primes supply
  p := <-ps
  p = <-ps
  nums := make(chan int)
  go NumsFromBy(5,2,nums)        // end of setup
  for i := 0; ; i++ {
    n := <-nums
    if n < q {
    	out <- n                 // n is prime
    } else {
        ch1 := make(chan int)
        go Filter(nums, ch1, p)  // postponed creation of a filter
        nums = ch1
    	p = <-ps
    	q = p*p
    }
  }
}

func main() {
  ch := make(chan int)
  go Sieve(ch)
  fmt.Print("First twenty:")
  for i := 0; i < 20; i++ {
    fmt.Print(" ", <-ch)
  }
  fmt.Println()
}
