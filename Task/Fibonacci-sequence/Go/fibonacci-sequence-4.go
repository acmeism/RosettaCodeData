func fib(c chan int) {
	a, b := 0, 1
	for {
		c <- a
		a, b = b, a+b
	}
}

func main() {
	c := make(chan int)
	go fib(c)
	for i := 0; i < 10; i++ {
		fmt.println(<-c)
	}
}
