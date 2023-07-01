package main

import (
    "fmt"

    "github.com/biogo/biogo/align"
    ab "github.com/biogo/biogo/alphabet"
    "github.com/biogo/biogo/feat"
    "github.com/biogo/biogo/seq/linear"
)

func main() {
    // Alphabets for things like DNA are predefined in biogo, but we
    // define our own here.
    lc := ab.Must(ab.NewAlphabet("-abcdefghijklmnopqrstuvwxyz",
        feat.Undefined, '-', 0, true))
    // Construct scoring matrix for Needleman-Wunch algorithm.
    // We leave zeros on the diagonal for the Levenshtein distance of an
    // exact match and put -1s everywhere else for the Levenshtein distance
    // of an edit.
    nw := make(align.NW, lc.Len())
    for i := range nw {
        r := make([]int, lc.Len())
        nw[i] = r
        for j := range r {
            if j != i {
                r[j] = -1
            }
        }
    }
    // define input sequences
    a := &linear.Seq{Seq: ab.BytesToLetters([]byte("rosettacode"))}
    a.Alpha = lc
    b := &linear.Seq{Seq: ab.BytesToLetters([]byte("raisethysword"))}
    b.Alpha = lc
    // perform alignment
    aln, err := nw.Align(a, b)
    // format and display result
    if err != nil {
        fmt.Println(err)
        return
    }
    fa := align.Format(a, b, aln, '-')
    fmt.Printf("%s\n%s\n", fa[0], fa[1])
    aa := fmt.Sprint(fa[0])
    ba := fmt.Sprint(fa[1])
    ma := make([]byte, len(aa))
    for i := range ma {
        if aa[i] == ba[i] {
            ma[i] = ' '
        } else {
            ma[i] = '|'
        }
    }
    fmt.Println(string(ma))
}
