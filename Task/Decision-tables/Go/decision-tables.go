package main

import (
    "errors"
    "fmt"
    "os"
)

type dtText struct {
    rules, text string
}

var ptText = []dtText{
    {"YYYYNNNN", "Printer does not print"},
    {"YYNNYYNN", "A red light is flashing"},
    {"YNYNYNYN", "Printer is unrecognised"},
    {"--------", ""},
    {"  X     ", "Check the power cable"},
    {"X X     ", "Check the printer-computer cable"},
    {"X X X X ", "Ensure printer software is installed"},
    {"XX  XX  ", "Check/replace ink"},
    {" X X    ", "Check for paper jam"},
}

type dtMap map[string][]string

func compileDT(t []dtText) (dtMap, error) {
    if len(t) == 0 {
        return nil, errors.New("Empty decision table")
    }
    var conditions, actions []dtText
    ruleColumns := len(t[0].rules)
    for i, row := range t {
        if len(row.rules) != ruleColumns {
            return nil, errors.New("Inconsistent number of rule columns")
        }
        if len(row.text) == 0 {
            if conditions != nil {
                return nil, errors.New("Multple separator lines")
            }
            if i == 0 {
                return nil, errors.New("No conditions specified")
            }
            if i == len(t)-1 {
                return nil, errors.New("No actions specified")
            }
            conditions = t[:i]
            actions = t[i+1:]
        }
    }
    if conditions == nil {
        return nil, errors.New("Missing separator line")
    }
    m := make(map[string][]string, ruleColumns)
    kb := make([]byte, len(conditions))
    for col := 0; col < ruleColumns; col++ {
        for i, c := range conditions {
            kb[i] = c.rules[col]
        }
        key := string(kb)
        for _, a := range actions {
            if a.rules[col] != ' ' {
                m[key] = append(m[key], a.text)
            }
        }
    }
    return m, nil
}

func init() {
    var err error
    if ptMap, err = compileDT(ptText); err != nil {
        fmt.Println(err)
        os.Exit(1)
    }
}

var ptMap dtMap

func main() {
    for _, a := range ptMap["NYY"] {
        fmt.Println(a)
    }
}
