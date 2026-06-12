package main

import "core:fmt"
import "core:slice"
main ::proc(){

    shift := [9]int{1, 2,3,4,5,6,7,8,9}
    slice.rotate_left(shift[:],3)
    fmt.println(shift)

}
