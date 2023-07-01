import os
import rand
import rand.seed
import math

fn main() {
    rand.seed(seed.time_seed_array(2))
    mut n := []int{len: 4}
    for i in 0.. n.len {
        n[i] = rand.intn(9) or {0}
    }
    println("Your numbers: $n")
    expr := os.input("Enter RPN: ")
    if expr.len != 7 {
        println("invalid. expression length must be 7." +
            " (4 numbers, 3 operators, no spaces)")
        return
    }
    mut stack := []f64{len: 0, cap:4}
    for r in expr.split('') {
        if r >= '0' && r <= '9' {
            if n.len == 0 {
                println("too many numbers.")
                return
            }
            mut i := 0
            for n[i] != r.int() {
                i++
                if i == n.len {
                    println("wrong numbers.")
                    return
                }
            }
            n.delete(n.index(r.int()))
            stack << f64(r[0]-'0'[0])
            continue
        }
        if stack.len < 2 {
            println("invalid expression syntax.")
            return
        }
        match r {
            '+' {
                stack[stack.len-2] += stack[stack.len-1]
            }
            '-' {
                stack[stack.len-2] -= stack[stack.len-1]
            }
            '*' {
                stack[stack.len-2] *= stack[stack.len-1]
            }
            '/' {
                stack[stack.len-2] /= stack[stack.len-1]
            }
            else {
                println("$r invalid.")
                return
            }
        }
        stack = stack[..stack.len-1]
    }
    if math.abs(stack[0]-24) > 1e-6 {
        println("incorrect. ${stack[0]} != 24")
    } else {
        println("correct.")
    }
}
