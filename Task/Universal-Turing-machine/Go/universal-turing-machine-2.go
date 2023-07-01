package main

import (
        ".." // XXX path to above turing package
        "fmt"
)

func main() {
        var incrementer = turing.NewMachine([]turing.Rule{
                {"q0", '1', '1', turing.Right, "q0"},
                {"q0", 'B', '1', turing.Stay, "qf"},
        })
        input := turing.NewTape('B', 0, []turing.Symbol{'1', '1', '1'})
        cnt, output := incrementer.Run(input)
        fmt.Println("Turing machine halts after", cnt, "operations")
        fmt.Println("Resulting tape:", output)

        var beaver = turing.NewMachine([]turing.Rule{
                {"a", '0', '1', turing.Right, "b"},
                {"a", '1', '1', turing.Left, "c"},
                {"b", '0', '1', turing.Left, "a"},
                {"b", '1', '1', turing.Right, "b"},
                {"c", '0', '1', turing.Left, "b"},
                {"c", '1', '1', turing.Stay, "halt"},
        })
        cnt, output = beaver.Run(turing.NewTape('0', 0, nil))
        fmt.Println("Turing machine halts after", cnt, "operations")
        fmt.Println("Resulting tape:", output)

        beaver = turing.NewMachine([]turing.Rule{
                {"A", '0', '1', turing.Right, "B"},
                {"A", '1', '1', turing.Left, "C"},
                {"B", '0', '1', turing.Right, "C"},
                {"B", '1', '1', turing.Right, "B"},
                {"C", '0', '1', turing.Right, "D"},
                {"C", '1', '0', turing.Left, "E"},
                {"D", '0', '1', turing.Left, "A"},
                {"D", '1', '1', turing.Left, "D"},
                {"E", '0', '1', turing.Stay, "H"},
                {"E", '1', '0', turing.Left, "A"},
        })
        cnt, output = beaver.Run(turing.NewTape('0', 0, nil))
        fmt.Println("Turing machine halts after", cnt, "operations")
        fmt.Println("Resulting tape has", len(output.Data()), "cells")

        var sort = turing.NewMachine([]turing.Rule{
                // Moving right, first b→B;s1
                {"s0", 'a', 'a', turing.Right, "s0"},
                {"s0", 'b', 'B', turing.Right, "s1"},
                {"s0", ' ', ' ', turing.Left, "se"},
                // Conintue right to end of tape → s2
                {"s1", 'a', 'a', turing.Right, "s1"},
                {"s1", 'b', 'b', turing.Right, "s1"},
                {"s1", ' ', ' ', turing.Left, "s2"},
                // Continue left over b.  a→b;s3, B→b;se
                {"s2", 'a', 'b', turing.Left, "s3"},
                {"s2", 'b', 'b', turing.Left, "s2"},
                {"s2", 'B', 'b', turing.Left, "se"},
                // Continue left until B→a;s0
                {"s3", 'a', 'a', turing.Left, "s3"},
                {"s3", 'b', 'b', turing.Left, "s3"},
                {"s3", 'B', 'a', turing.Right, "s0"},
                // Move to tape start → halt
                {"se", 'a', 'a', turing.Left, "se"},
                {"se", ' ', ' ', turing.Right, "see"},
        })
        input = turing.NewTape(' ', 0, []turing.Symbol("abbabbabababab"))
        cnt, output = sort.Run(input)
        fmt.Println("Turing machine halts after", cnt, "operations")
        fmt.Println("Resulting tape:", output)
}
