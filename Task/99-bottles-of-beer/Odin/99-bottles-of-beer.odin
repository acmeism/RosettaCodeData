package main

import "core:fmt"
printf :: fmt.printf //Give fn on right an arbitrary name, or 9x fmt.printf("...")

bob :: proc( n: int , x: int){
	for i := x; i > 0 ; i -=1 {
		if      n >= 2		do printf("%d bottles of beer",n)
		else if n == 1 		do printf("1 bottle of beer")
		else if n == 0 		do printf("No more bottles of beer")

		if i == 1 	do printf(".\n")
		if i > 1 	do printf(" on the wall.\n")
		if i > 2 	do printf("\n")
	}
}

main :: proc(){
	n := 99
	bob(n, 2)
	for i := n - 1 ; i >= 0 ; i -= 1 {
		printf("Take one down; pass it around.\n")
		bob(i, 3)
	}
	printf ("Go to the store and buy some more.\n")
	printf ("%i bottles of beer on the wall.\n",n)
}
