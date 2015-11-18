package main
import "fmt"

// Send the sequence 2, 3, 4, ... to channel 'ch'.
func Generate(ch chan<- int) {
	for i := 2; ; i++ {
		ch <- i // Send 'i' to channel 'ch'.
	}
}

// Copy the values from channel 'in' to channel 'out',
// removing those divisible by 'prime'.
// 'in' assumed to send increasing numbers
func Filter(in <-chan int, out chan<- int, prime int) {
        m := prime + prime
	for {
		i := <-in // Receive value from 'in'.
		for i > m {
			m = m + prime
			}
		if i < m {
			out <- i // Send 'i' to 'out'.
			}
	}
}

// The prime sieve: Daisy-chain Filter processes.
func main() {
	ch := make(chan int) // Create a new channel.
	go Generate(ch)      // Launch Generate goroutine.
	for i := 0; i < 100; i++ {
		prime := <-ch
		fmt.Printf("%4d", prime)
		if (i+1)%20==0 {
			fmt.Println("")
			}
		ch1 := make(chan int)
		go Filter(ch, ch1, prime)
		ch = ch1
	}
}
