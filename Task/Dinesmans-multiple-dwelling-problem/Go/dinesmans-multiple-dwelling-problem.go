package main

import "fmt"

// The program here is restricted to finding assignments of tenants (or more
// generally variables with distinct names) to floors (or more generally
// integer values.)  It finds a solution assigning all tenants and assigning
// them to different floors.

// Change number and names of tenants here.  Adding or removing names is
// allowed but the names should be distinct; the code is not written to handle
// duplicate names.
var tenants = []string{"Baker", "Cooper", "Fletcher", "Miller", "Smith"}

// Change the range of floors here.  The bottom floor does not have to be 1.
// These should remain non-negative integers though.
const bottom = 1
const top = 5

// A type definition for readability.  Do not change.
type assignments map[string]int

// Change rules defining the problem here.  Change, add, or remove rules as
// desired.  Each rule should first be commented as human readable text, then
// coded as a function.  The function takes a tentative partial list of
// assignments of tenants to floors and is free to compute anything it wants
// with this information.  Other information available to the function are
// package level defintions, such as top and bottom.  A function returns false
// to say the assignments are invalid.
var rules = []func(assignments) bool{
    // Baker does not live on the top floor
    func(a assignments) bool {
        floor, assigned := a["Baker"]
        return !assigned || floor != top
    },
    // Cooper does not live on the bottom floor
    func(a assignments) bool {
        floor, assigned := a["Cooper"]
        return !assigned || floor != bottom
    },
    // Fletcher does not live on either the top or the bottom floor
    func(a assignments) bool {
        floor, assigned := a["Fletcher"]
        return !assigned || (floor != top && floor != bottom)
    },
    // Miller lives on a higher floor than does Cooper
    func(a assignments) bool {
        if m, assigned := a["Miller"]; assigned {
            c, assigned := a["Cooper"]
            return !assigned || m > c
        }
        return true
    },
    // Smith does not live on a floor adjacent to Fletcher's
    func(a assignments) bool {
        if s, assigned := a["Smith"]; assigned {
            if f, assigned := a["Fletcher"]; assigned {
                d := s - f
                return d*d > 1
            }
        }
        return true
    },
    // Fletcher does not live on a floor adjacent to Cooper's
    func(a assignments) bool {
        if f, assigned := a["Fletcher"]; assigned {
            if c, assigned := a["Cooper"]; assigned {
                d := f - c
                return d*d > 1
            }
        }
        return true
    },
}

// Assignment program, do not change.  The algorithm is a depth first search,
// tentatively assigning each tenant in order, and for each tenant trying each
// unassigned floor in order.  For each tentative assignment, it evaluates all
// rules in the rules list and backtracks as soon as any one of them fails.
//
// This algorithm ensures that the tenative assignments have only names in the
// tenants list, only floor numbers from bottom to top, and that tentants are
// assigned to different floors.  These rules are hard coded here and do not
// need to be coded in the the rules list above.
func main() {
    a := assignments{}
    var occ [top + 1]bool
    var df func([]string) bool
    df = func(u []string) bool {
        if len(u) == 0 {
            return true
        }
        tn := u[0]
        u = u[1:]
    f:
        for f := bottom; f <= top; f++ {
            if !occ[f] {
                a[tn] = f
                for _, r := range rules {
                    if !r(a) {
                        delete(a, tn)
                        continue f
                    }
                }
                occ[f] = true
                if df(u) {
                    return true
                }
                occ[f] = false
                delete(a, tn)
            }
        }
        return false
    }
    if !df(tenants) {
        fmt.Println("no solution")
        return
    }
    for t, f := range a {
        fmt.Println(t, f)
    }
}
