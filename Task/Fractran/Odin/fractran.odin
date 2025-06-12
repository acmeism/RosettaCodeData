package main

import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"
import "core:text/match"
import "core:math"


main :: proc() {
   // fmt.println(os.args)

    n:int
    number:int
    number_conv:bool
    fracts:[dynamic]int
    defer delete(fracts)

    n,number_conv = strconv.parse_int(os.args[1])
    assert(number_conv, "Number must be given in first place!")
    assert(len(os.args)>1,"no command line arguments given")

    data:="17/91 78/85 19/51 23/38 29/33 77/29 95/23 77/19 1/17 11/13 13/11 15/14 15/2 55/1"

    ss := strings.split(string(data), " ")
    defer delete(ss)
	

    a: [dynamic]string
    dummy:[]string
    defer delete(a)
    defer delete(dummy)

    for i in ss{
        dummy =strings.split(i,"/")
        for j in dummy{
        //    fmt.println(j)

            append_elem(&a,j)
        }
    }

    for k in a{
     //   fmt.println(k)
        number,number_conv = strconv.parse_int(k)
        assert(number_conv, "Number must be given in program")
        append_elem(&fracts,number)
    }


   // fmt.println(len(fracts))
    cond:int
    buf: [256]byte
    bb:int
    end:=0
    fmt.println(n)
    frac: for j:=0;j<len(fracts);{
        cond = (n*fracts[j])%fracts[j+1]

        if (cond==0){

            n= (n*fracts[j])/fracts[j+1]
            fmt.println(n)
            j=0
            end+=1
            if end==19{
                break frac
            }
        }
        else{
            j=j+2
        }

    }

}
