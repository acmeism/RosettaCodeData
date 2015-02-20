package main

import (
    "fmt"
    "log"
    "strconv"
)

// A casting out nines algorithm.

// Quoting from: http://mathforum.org/library/drmath/view/55926.html
/*
First, for any number we can get a single digit, which I will call the
"check digit," by repeatedly adding the digits. That is, we add the
digits of the number, then if there is more than one digit in the
result we add its digits, and so on until there is only one digit
left.

...

You may notice that when you add the digits of 6395, if you just
ignore the 9, and the 6+3 = 9, you still end up with 5 as your check
digit. This is because any 9's make no difference in the result.
That's why the process is called "casting out" nines. Also, at any
step in the process, you can add digits, not just at the end: to do
8051647, I can say 8 + 5 = 13, which gives 4; plus 1 is 5, plus 6 is
11, which gives 2, plus 4 is 6, plus 7 is 13 which gives 4. I never
have to work with numbers bigger than 18.
*/
// The twist is that co9Peterson returns a function to do casting out nines
// in any specified base from 2 to 36.
func co9Peterson(base int) (cob func(string) (byte, error), err error) {
    if base < 2 || base > 36 {
        return nil, fmt.Errorf("co9Peterson: %d invalid base", base)
    }
    // addDigits adds two digits in the specified base.
    // People perfoming casting out nines by hand would usually have their
    // addition facts memorized.  In a program, a lookup table might be
    // analogous, but we expediently use features of the programming language
    // to add digits in the specified base.
    addDigits := func(a, b byte) (string, error) {
        ai, err := strconv.ParseInt(string(a), base, 64)
        if err != nil {
            return "", err
        }
        bi, err := strconv.ParseInt(string(b), base, 64)
        if err != nil {
            return "", err
        }
        return strconv.FormatInt(ai+bi, base), nil
    }
    // a '9' in the specified base.  that is, the greatest digit.
    s9 := strconv.FormatInt(int64(base-1), base)
    b9 := s9[0]
    // define result function.  The result function may return an error
    // if n is not a valid number in the specified base.
    cob = func(n string) (r byte, err error) {
        r = '0'
        for i := 0; i < len(n); i++ { // for each digit of the number
            d := n[i]
            switch {
            case d == b9: // if the digit is '9' of the base, cast it out
                continue
            // if the result so far is 0, the digit becomes the result
            case r == '0':
                r = d
                continue
            }
            // otherwise, add the new digit to the result digit
            s, err := addDigits(r, d)
            if err != nil {
                return 0, err
            }
            switch {
            case s == s9: // if the sum is "9" of the base, cast it out
                r = '0'
                continue
            // if the sum is a single digit, it becomes the result
            case len(s) == 1:
                r = s[0]
                continue
            }
            // otherwise, reduce this two digit intermediate result before
            // continuing.
            r, err = cob(s)
            if err != nil {
                return 0, err
            }
        }
        return
    }
    return
}

// Subset code required by task.  Given a base and a range specified with
// beginning and ending number in that base, return candidate Kaprekar numbers
// based on the observation that k%(base-1) must equal (k*k)%(base-1).
// For the % operation, rather than the language built-in operator, use
// the method of casting out nines, which in fact implements %(base-1).
func subset(base int, begin, end string) (s []string, err error) {
    // convert begin, end to native integer types for easier iteration
    begin64, err := strconv.ParseInt(begin, base, 64)
    if err != nil {
        return nil, fmt.Errorf("subset begin: %v", err)
    }
    end64, err := strconv.ParseInt(end, base, 64)
    if err != nil {
        return nil, fmt.Errorf("subset end: %v", err)
    }
    // generate casting out nines function for specified base
    cob, err := co9Peterson(base)
    if err != nil {
        return
    }
    for k := begin64; k <= end64; k++ {
        ks := strconv.FormatInt(k, base)
        rk, err := cob(ks)
        if err != nil { // assertion
            panic(err) // this would indicate a bug in subset
        }
        rk2, err := cob(strconv.FormatInt(k*k, base))
        if err != nil { // assertion
            panic(err) // this would indicate a bug in subset
        }
        // test for candidate Kaprekar number
        if rk == rk2 {
            s = append(s, ks)
        }
    }
    return
}

var testCases = []struct {
    base       int
    begin, end string
    kaprekar   []string
}{
    {10, "1", "100", []string{"1", "9", "45", "55", "99"}},
    {17, "10", "gg", []string{"3d", "d4", "gg"}},
}

func main() {
    for _, tc := range testCases {
        fmt.Printf("\nTest case base = %d, begin = %s, end = %s:\n",
            tc.base, tc.begin, tc.end)
        s, err := subset(tc.base, tc.begin, tc.end)
        if err != nil {
            log.Fatal(err)
        }
        fmt.Println("Subset:  ", s)
        fmt.Println("Kaprekar:", tc.kaprekar)
        sx := 0
        for _, k := range tc.kaprekar {
            for {
                if sx == len(s) {
                    fmt.Printf("Fail:", k, "not in subset")
                    return
                }
                if s[sx] == k {
                    sx++
                    break
                }
                sx++
            }
        }
        fmt.Println("Valid subset.")
    }
}
