package main

import "core:fmt"

collatz :: proc(array:^[dynamic]int,n:int){
    i:=1
    n:=n
    for n!=1{

        if (n%2==0){
            n=n/2
            append(&array^,n)
        }
        else{
            n=3*n+1
            append(&array^,n)
        }

    }
}

main :: proc() {
	n:=27

    max:=0
    max_length:=0

    dummy:[dynamic]int
    defer delete(dummy)
    append(&dummy,n)
    collatz(&dummy,n)


    fmt.println("the first four of sequence for 27: ")
    for jj:=0;jj<4;jj+=1{
        fmt.println(dummy[jj])
    }
    fmt.println("the last four of sequence for 27: ")
    for jj:=0;jj<4;jj+=1{
        fmt.println(dummy[len(dummy)-4+jj])
    }
    fmt.println("length of sequence for 27")
    fmt.println(len(dummy))


    for (len(dummy)>0){
        pop(&dummy)
    }

    for ii:=1;ii<100000;ii+=1{
        append(&dummy,ii)
        collatz(&dummy,ii)
        if(len(dummy)>max_length){
            max = ii
            max_length=len(dummy)
        }
        for (len(dummy)>0){
            pop(&dummy)
        }
    }
    fmt.println("Max number: ")
    fmt.println(max)
    fmt.println("Max length: ")
    fmt.println(max_length)
}
