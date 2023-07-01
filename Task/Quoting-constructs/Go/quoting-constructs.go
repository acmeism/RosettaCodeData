package main

import (
    "fmt"
    "os"
    "regexp"
    "strconv"
)

/* Quoting constructs in Go. */

// In Go a Unicode codepoint, expressed as a 32-bit integer, is referred to as a 'rune'
// but the more familiar term 'character' will be used instead here.

// Character literal (single quotes).
// Can contain any single character including an escaped character.
var (
    rl1 = 'a'
    rl2 = '\'' // single quote can only be included in escaped form
)

// Interpreted string literal (double quotes).
// A sequence of characters including escaped characters.
var (
    is1 = "abc"
    is2 = "\"ab\tc\"" // double quote can only be included in escaped form
)

// Raw string literal(single back quotes).
// Can contain any character including a 'physical' new line but excluding back quote.
// Escaped characters are interpreted literally i.e. `\n` is backslash followed by n.
// Raw strings are typically used for hard-coding pieces of text perhaps
// including single and/or double quotes without the need to escape them.
// They are particularly useful for regular expressions.
var (
    rs1 = `
first"
second'
third"
`
    rs2 = `This is one way of including a ` + "`" + ` in a raw string literal.`
    rs3 = `\d+` // a sequence of one or more digits in a regular expression
)

func main() {
    fmt.Println(rl1, rl2) // prints the code point value not the character itself
    fmt.Println(is1, is2)
    fmt.Println(rs1)
    fmt.Println(rs2)
    re := regexp.MustCompile(rs3)
    fmt.Println(re.FindString("abcd1234efgh"))

    /* None of the above quoting constructs can deal directly with interpolation.
       This is done instead using library functions.
    */

    // C-style using %d, %f, %s etc. within a 'printf' type function.
    n := 3
    fmt.Printf("\nThere are %d quoting constructs in Go.\n", n)

    // Using a function such as fmt.Println which can take a variable
    // number of arguments, of any type, and print then out separated by spaces.
    s := "constructs"
    fmt.Println("There are", n, "quoting", s, "in Go.")

    // Using the function os.Expand which requires a mapper function to fill placeholders
    // denoted by ${...} within a string.
    mapper := func(placeholder string) string {
        switch placeholder {
        case "NUMBER":
            return strconv.Itoa(n)
        case "TYPES":
            return s
        }
        return ""
    }
    fmt.Println(os.Expand("There are ${NUMBER} quoting ${TYPES} in Go.", mapper))
}
