package main

import (
    "bufio"
    "errors"
    "fmt"
    "go/ast"
    "go/parser"
    "go/token"
    "os"
    "reflect"
)

func main() {
    in := bufio.NewScanner(os.Stdin)
    for {
        fmt.Print("Expr:  ")
        in.Scan()
        if err := in.Err(); err != nil {
            fmt.Println(err)
            return
        }
        if !tt(in.Text()) {
            return
        }
    }
}

func tt(expr string) bool {
    // call library parser
    tree, err := parser.ParseExpr(expr)
    if err != nil {
        fmt.Println(err)
        return false
    }
    // create handy object to pass around
    e := &evaluator{nil, map[string]bool{}, tree}
    // library tree traversal function calls e.Visit for each node.
    // use this to collect variables of the expression.
    ast.Walk(e, tree)
    // print headings for truth table
    for _, n := range e.names {
        fmt.Printf("%-6s", n)
    }
    fmt.Println(" ", expr)
    // start recursive table generation function on first variable
    e.evalVar(0)
    return true
}

type evaluator struct {
    names []string        // variables, in order of appearance
    val   map[string]bool // map variables to boolean values
    tree  ast.Expr        // parsed expression as ast
}

// visitor function called by library Walk function.
// builds a list of unique variable names.
func (e *evaluator) Visit(n ast.Node) ast.Visitor {
    if id, ok := n.(*ast.Ident); ok {
        if !e.val[id.Name] {
            e.names = append(e.names, id.Name)
            e.val[id.Name] = true
        }
    }
    return e
}

// method recurses for each variable of the truth table, assigning it to
// false, then true.  At bottom of recursion, when all variables are
// assigned, it evaluates the expression and outputs one line of the
// truth table
func (e *evaluator) evalVar(nx int) bool {
    if nx == len(e.names) {
        // base case
        v, err := evalNode(e.tree, e.val)
        if err != nil {
            fmt.Println(" ", err)
            return false
        }
        // print variable values
        for _, n := range e.names {
            fmt.Printf("%-6t", e.val[n])
        }
        // print expression value
        fmt.Println(" ", v)
        return true
    }
    // recursive case
    for _, v := range []bool{false, true} {
        e.val[e.names[nx]] = v
        if !e.evalVar(nx + 1) {
            return false
        }
    }
    return true
}

// recursively evaluate ast
func evalNode(nd ast.Node, val map[string]bool) (bool, error) {
    switch n := nd.(type) {
    case *ast.Ident:
        return val[n.Name], nil
    case *ast.BinaryExpr:
        x, err := evalNode(n.X, val)
        if err != nil {
            return false, err
        }
        y, err := evalNode(n.Y, val)
        if err != nil {
            return false, err
        }
        switch n.Op {
        case token.AND:
            return x && y, nil
        case token.OR:
            return x || y, nil
        case token.XOR:
            return x != y, nil
        default:
            return unsup(n.Op)
        }
    case *ast.UnaryExpr:
        x, err := evalNode(n.X, val)
        if err != nil {
            return false, err
        }
        switch n.Op {
        case token.XOR:
            return !x, nil
        default:
            return unsup(n.Op)
        }
    case *ast.ParenExpr:
        return evalNode(n.X, val)
    }
    return unsup(reflect.TypeOf(nd))
}

func unsup(i interface{}) (bool, error) {
    return false, errors.New(fmt.Sprintf("%v unsupported", i))
}
