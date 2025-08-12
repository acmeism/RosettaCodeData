#+feature dynamic-literals
package main

import "core:fmt"
import "core:math"
import "core:os"
import "core:strconv"

main :: proc() {

    // start with sieve.exe 120 to get primes until 120
    n:=0
    ok:=false
    assert(len(os.args)==2,"Give integer as argument!")
    if len(os.args) == 2 {
        argument := os.args[1]
        n, ok = strconv.parse_int(argument)
        assert(ok, "Second argument was not an integer")
        assert(n>2, "n must be bigger than two")
    }

    result := [dynamic]i64{0}
    defer delete(result)

    for i:=1;i<n;i+=1 {
        append(&result, 0)
    }

    // outer loop with square root as limit
    limit := i64(math.round_f64(math.sqrt_f64(f64(n))))



    // some_array : [n]i32
    // fill array with values
    for i:=1;i<n;i+=1 {
        result[i] = i64(i)
    }
    // start from two
    j:=2
    for i:=2; i<= int(limit); i+=1 {
       // set multiples as zero
        for j=2; j*i<int(n); j+=1 {
            result[j*i]=0
        }

    }
    // print primes or numbers that aren't multiples
	for i:=2;i<n;i+=1 {
        if(result[i]!=0) {

            fmt.print(result[i])
           fmt.print(" ")
        }

    }

}
