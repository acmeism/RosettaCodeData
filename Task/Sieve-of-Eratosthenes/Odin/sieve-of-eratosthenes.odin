package main

import "core:fmt"
import "core:math"


main :: proc() {

    n :: 120
    // outer loop with square root as limit
    limit := i32(math.round_f16(math.sqrt_f16(n)))

    array : [n]i32
    // fill array with values
    for i:=1;i<n;i+=1 {
        array[i] = i32(i)
    }
    // start from two
    j:=2
    for i:=2; i<= int(limit); i+=1 {
       // set multiples as zero
        for j=2; j*i<int(n); j+=1 {
            array[j*i]=0
        }

    }
    // print primes or numbers that aren't multiples
	for i:=0;i<n;i+=1 {
        if(array[i]!=0) {
            fmt.println(array[i])
        }

    }


}
