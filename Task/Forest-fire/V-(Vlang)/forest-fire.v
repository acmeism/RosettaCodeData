import rand
import strings
import os

const (
    rows = 20
    cols = 30
    p    = .01
    f    = .001
)

const rx = rows + 2
const cx = cols + 2

fn main() {
    mut odd := []string{len: rx*cx}
    mut even := []string{len: rx*cx}
    for r := 1; r <= rows; r++ {
        for c := 1; c <= cols; c++ {
            if rand.intn(2) or {1} == 1 {
                odd[r*cx+c] = 'T'
            }
        }
    }
    mut _ := ''
    for {
        print_row(odd)
        step(mut even, odd)
        _ = os.input('')

        print_row(even)
        step(mut odd, even)
        _ = os.input('')
    }
}

fn print_row(model []string) {
    println(strings.repeat_string("__", cols))
    println('')
    for r := 1; r <= rows; r++ {
        for c := 1; c <= cols; c++ {
            if model[r*cx+c] == '0' {
                print("  ")
            } else {
                print(" ${model[r*cx+c]}")
            }
        }
        println('')
    }
}

fn step(mut dst []string, src []string) {
    for r := 1; r <= rows; r++ {
        for c := 1; c <= cols; c++ {
            x := r*cx + c
            dst[x] = src[x]
            match dst[x] {
                '#' {
                    // rule 1. A burning cell turns into an empty cell
                    dst[x] = '0'
                }
                'T' {
                    // rule 2. A tree will burn if at least one neighbor is burning
                    if src[x-cx-1]=='#'  || src[x-cx]=='#' || src[x-cx+1]=='#' ||
                    src[x-1] == '#'  ||                   src[x+1] == '#'  ||
                    src[x+cx-1]=='#' || src[x+cx]=='#' || src[x+cx+1] == '#' {
                        dst[x] = '#'

                    // rule 3. A tree ignites with probability f
                    // even if no neighbor is burning
                    } else if rand.f64() < f {
                        dst[x] = '#'
                    }
                }
                else {
                    // rule 4. An empty space fills with a tree with probability p
                    if rand.f64() < p {
                        dst[x] = 'T'
                    }
                }
            }
        }
    }
}
