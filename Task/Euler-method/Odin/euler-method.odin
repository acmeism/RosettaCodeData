package main

import "core:fmt"
import "core:math"

ivp_euler ::proc(y:f32,step:i32,end:i32){

    y:=y
    t:=i32(0)

    for ;t<=end;t+=step{
        if(t%10==0){fmt.printfln("%.3f", y)}
        y+=f32(step)*cooling(f32(t),y)
    }
}

cooling :: proc(t:f32,temp:f32)-> f32{
    return -0.07* (temp-20.0)
}

analytic :: proc(){
    for t := 0; t <= 100; t += 10{
        fmt.printfln("%.3f",20+80*math.exp_f32(f32(-0.07)*f32(t)))
    }
}

main :: proc() {
    fmt.println("Step: 2 Seconds")
	ivp_euler(100.0, 2,100)
    fmt.println("Step: 5 Seconds")
    ivp_euler(100.0, 5, 100)
    fmt.println("Step: 10 Seconds")
	ivp_euler(100.0, 10, 100)
    fmt.println("Analytic")
    analytic()
}
