package main

import (
    "fmt"
    "go/ast"
    "go/parser"
    "log"
)

func labelStr(label int) string {
    return fmt.Sprintf("_%04d", label)
}

type binexp struct {
    op, left, right string
    kind, index     int
}

func main() {
    x := "(one + two) * three - four * five"
    fmt.Println("Expression to parse: ", x)
    f, err := parser.ParseExpr(x)
    if err != nil {
        log.Fatal(err)
    }

    fmt.Println("\nThe abstract syntax tree for this expression:")
    ast.Print(nil, f)

    fmt.Println("\nThe corresponding three-address code:")
    var binexps []binexp
    // Inspect nodes in depth-first order.
    ast.Inspect(f, func(n ast.Node) bool {
        switch x := n.(type) {
        case *ast.BinaryExpr:
            sx, ok1 := x.X.(*ast.Ident)
            sy, ok2 := x.Y.(*ast.Ident)
            op := x.Op.String()
            if ok1 && ok2 {
                binexps = append(binexps, binexp{op, sx.Name, sy.Name, 3, 0})
            } else if !ok1 && ok2 {
                binexps = append(binexps, binexp{op, "<addr>", sy.Name, 2, 0})
            } else if ok1 && !ok2 {
                binexps = append(binexps, binexp{op, sx.Name, "<addr>", 1, 0})
            } else {
                binexps = append(binexps, binexp{op, "<addr>", "<addr>", 0, 0})
            }
        }
        return true
    })

    for i := 0; i < len(binexps); i++ {
        binexps[i].index = i
    }

    label, last := 0, -1
    var ops, args []binexp
    var labels []string
    for i, be := range binexps {
        if be.kind == 0 {
            ops = append(ops, be)
        }
        if be.kind != 3 {
            continue
        }
        label++
        ls := labelStr(label)
        fmt.Printf("    %s = %s %s %s\n", ls, be.left, be.op, be.right)
        for j := i - 1; j > last; j-- {
            be2 := binexps[j]
            if be2.kind == 2 {
                label++
                ls2 := labelStr(label)
                fmt.Printf("    %s = %s %s %s\n", ls2, ls, be2.op, be2.right)
                ls = ls2
                be = be2
            } else if be2.kind == 1 {
                label++
                ls2 := labelStr(label)
                fmt.Printf("    %s = %s %s %s\n", ls2, be2.left, be2.op, ls)
                ls = ls2
                be = be2
            }
        }
        args = append(args, be)
        labels = append(labels, ls)
        lea, leo := len(args), len(ops)
        for lea >= 2 {
            if i < len(binexps)-1 && args[lea-2].index <= ops[leo-1].index {
                break
            }
            label++
            ls2 := labelStr(label)
            fmt.Printf("    %s = %s %s %s\n", ls2, labels[lea-2], ops[leo-1].op, labels[lea-1])
            ops = ops[0 : leo-1]
            args = args[0 : lea-1]
            labels = labels[0 : lea-1]
            lea--
            leo--
            args[lea-1] = be
            labels[lea-1] = ls2
        }
        last = i
    }
}
