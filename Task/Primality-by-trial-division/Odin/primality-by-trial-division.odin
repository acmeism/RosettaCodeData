package main

import "core:fmt"
import "core:math"

prime ::proc(n:i32)->bool{
    if (n<2){
        return false
    }
    else {

        test:=true
        for i:=2;i<=int(math.sqrt_f16(f16(n)));i+=1{
            if (n%i32(i))==0{
                return false
            }
        }
        return test
    }

}

main :: proc() {

    for i:=2;i<=100;i+=1{
        fmt.printf("%i: ", i)
        fmt.println(prime(i32(i)))
    }
}
