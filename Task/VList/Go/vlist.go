package main

import "fmt"

type vList struct {
    base   *vSeg
    offset int
}

type vSeg struct {
    next *vSeg
    ele  []vEle
}

// element type could be anything. i pick string to demonstrate the task.
type vEle string

// primary operation 1: locate the kth element.
func (v vList) index(i int) (r vEle) {
    if i >= 0 {
        i += v.offset
        for sg := v.base; sg != nil; sg = sg.next {
            if i < len(sg.ele) {
                return sg.ele[i]
            }
            i -= len(sg.ele)
        }
    }
    // consistent with the way Go panics on slice index out of range
    panic("index out of range")
}

// primary operation 2: add an element to the front of the VList.
func (v vList) cons(a vEle) vList {
    if v.base == nil {
        return vList{base: &vSeg{ele: []vEle{a}}}
    }
    if v.offset == 0 {
        l2 := len(v.base.ele) * 2
        ele := make([]vEle, l2)
        ele[l2-1] = a
        return vList{&vSeg{v.base, ele}, l2 - 1}
    }
    v.offset--
    v.base.ele[v.offset] = a
    return v
}

// primary operation 3: obtain a new array beginning at the second element
// of an old array
func (v vList) cdr() vList {
    if v.base == nil {
        // consistent with panic above.  (not consistent with lisp)
        panic("cdr on empty vList")
    }
    v.offset++
    if v.offset < len(v.base.ele) {
        return v
    }
    return vList{v.base.next, 0}
}

// primary operation 4:  compute the length of the list.  (It's O(1).)
func (v vList) length() int {
    if v.base == nil {
        return 0
    }
    return len(v.base.ele)*2 - v.offset - 1
}

// A handy method:  satisfy stringer interface for easy output.
func (v vList) String() string {
    if v.base == nil {
        return "[]"
    }
    r := fmt.Sprintf("[%v", v.base.ele[v.offset])
    for sg, sl := v.base, v.base.ele[v.offset+1:]; ; {
        for _, e := range sl {
            r = fmt.Sprintf("%s %v", r, e)
        }
        sg = sg.next
        if sg == nil {
            break
        }
        sl = sg.ele
    }
    return r + "]"
}

// One more method for demonstration purposes
func (v vList) printStructure() {
    fmt.Println("offset:", v.offset)
    for sg := v.base; sg != nil; sg = sg.next {
        fmt.Printf("  %q\n", sg.ele) // %q illustrates the string type
    }
    fmt.Println()
}

// demonstration program using the WP example data
func main() {
    var v vList
    fmt.Println("zero value for type.  empty vList:", v)
    v.printStructure()

    for a := '6'; a >= '1'; a-- {
        v = v.cons(vEle(a))
    }
    fmt.Println("demonstrate cons. 6 elements added:", v)
    v.printStructure()

    v = v.cdr()
    fmt.Println("demonstrate cdr. 1 element removed:", v)
    v.printStructure()

    fmt.Println("demonstrate length. length =", v.length())
    fmt.Println()

    fmt.Println("demonstrate element access. v[3] =", v.index(3))
    fmt.Println()

    v = v.cdr().cdr()
    fmt.Println("show cdr releasing segment. 2 elements removed:", v)
    v.printStructure()
}
