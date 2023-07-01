package main
import "fmt"

// Send the sequence 2, 3, 4, ... to channel 'out'
func Generate(out chan<- int) {
	for i := 2; ; i++ {
		out <- i                  // Send 'i' to channel 'out'
	}
}

// Copy the values from 'in' channel to 'out' channel,
//   removing the multiples of 'prime' by counting.
// 'in' is assumed to send increasing numbers
func Filter(in <-chan int, out chan<- int, prime int) {
        m := prime * prime                // start from square of prime
	for {
		i := <- in                // Receive value from 'in'
		for i > m {
			m = m + prime     // next multiple of prime
			}
		if i < m {
			out <- i          // Send 'i' to 'out'
			}
	}
}

// The prime sieve: Postponed-creation Daisy-chain of Filters
func Sieve(out chan<- int) {
	gen := make(chan int)             // Create a new channel
	go Generate(gen)                  // Launch Generate goroutine
	p := <- gen
	out <- p
	p = <- gen          // make recursion shallower ---->
	out <- p            // (Go channels are _push_, not _pull_)
	
	base_primes := make(chan int)     // separate primes supply
	go Sieve(base_primes)
	bp := <- base_primes              // 2           <---- here
	bq := bp * bp                     // 4

	for  {
		p = <- gen
		if p == bq {                    // square of a base prime
			ft := make(chan int)
			go Filter(gen, ft, bp)  // filter multiples of bp in gen out
			gen = ft
			bp = <- base_primes     // 3
			bq = bp * bp            // 9
		} else {
			out <- p
		}
	}
}

func main() {
	sv := make(chan int)              // Create a new channel
	go Sieve(sv)                      // Launch Sieve goroutine
	lim := 25000
	for i := 0; i < lim; i++ {
		prime := <- sv
		if i >= (lim-10) {
		    fmt.Printf("%4d ", prime)
		    if (i+1)%20==0 {
			fmt.Println("")
		    }
		}
	}
}
