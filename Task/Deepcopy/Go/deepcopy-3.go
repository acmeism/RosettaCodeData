package main

import (
    "encoding/gob"
    "fmt"
    "os"
)

// capability requested by task
func deepcopy(dst, src interface{}) error {
    r, w, err := os.Pipe()
    if err != nil {
        return err
    }
    enc := gob.NewEncoder(w)
    err = enc.Encode(src)
    if err != nil {
        return err
    }
    dec := gob.NewDecoder(r)
    return dec.Decode(dst)
}

// define linked list type, an example of a recursive type
type link struct {
    Value string
    Next  *link
}

// method satisfies stringer interface for fmt.Println
func (l *link) String() string {
    if l == nil {
        return "nil"
    }
    s := "(" + l.Value
    for l = l.Next; l != nil; l = l.Next {
        s += " " + l.Value
    }
    return s + ")"
}

func main() {
    // create a linked list with two elements
    l1 := &link{"a", &link{Value: "b"}}
    // print original
    fmt.Println(l1)
    // declare a variable to hold deep copy
    var l2 *link
    // copy
    if err := deepcopy(&l2, l1); err != nil {
        fmt.Println(err)
        return
    }
    // print copy
    fmt.Println(l2)
    // now change contents of original list
    l1.Value, l1.Next.Value = "c", "d"
    // show that it is changed
    fmt.Println(l1)
    // show that copy is unaffected
    fmt.Println(l2)
}
