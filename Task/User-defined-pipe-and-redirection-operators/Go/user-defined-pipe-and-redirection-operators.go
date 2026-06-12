package main

import (
    "bufio"
    "fmt"
    "io"
    "io/ioutil"
    "regexp"
    "sort"
    "strings"
)

// fake file system
var fs = make(map[string]string)

type file struct{ name string }

func (f file) Write(p []byte) (int, error) {
    fs[f.name] += string(p)
    return len(p), nil
}

// role of > operator
func toName(name string, src io.Reader) {
    io.Copy(file{name}, src)
}

// role of < operator
func fromName(name string) io.Reader {
    return strings.NewReader(fs[name])
}

func tee(in io.Reader, name string) io.Reader {
    return io.TeeReader(in, file{name})
}

func grep(in io.Reader, pat string) io.Reader {
    pr, pw := io.Pipe()
    go func() {
        bf := bufio.NewReader(in)
        for {
            line, readErr := bf.ReadString('\n')
            if match, _ := regexp.MatchString(pat, line); match {
                _, writeErr := io.WriteString(pw, line)
                if writeErr != nil {
                    return
                }
            }
            if readErr != nil {
                pw.CloseWithError(readErr)
                return
            }
        }
        pw.Close()
    }()
    return pr
}

func uniq(in io.Reader) io.Reader {
    pr, pw := io.Pipe()
    go func() {
        bf := bufio.NewReader(in)
        var last string
        for {
            s, readErr := bf.ReadString('\n')
            switch readErr {
            case nil:
                if s != last {
                    _, writeErr := io.WriteString(pw, s)
                    if writeErr != nil {
                        return
                    }
                    last = s
                }
                continue
            case io.EOF:
                if s > "" && s+"\n" != last {
                    _, writeErr := io.WriteString(pw, s+"\n")
                    if writeErr != nil {
                        return
                    }
                }
                pw.Close()
            default:
                pw.CloseWithError(readErr)
            }
            return
        }
    }()
    return pr
}

func head(in io.Reader, lines int) io.Reader {
    pr, pw := io.Pipe()
    go func() {
        if lines <= 0 {
            lines = 10
        }
        for bf := bufio.NewReader(in); lines > 0; lines-- {
            s, readErr := bf.ReadString('\n')
            _, writeErr := io.WriteString(pw, s)
            if writeErr != nil {
                return
            }
            if readErr == nil {
                continue
            }
            if readErr == io.EOF {
                if s > "" {
                    io.WriteString(pw, "\n")
                }
            }
            pw.CloseWithError(readErr)
            return
        }
        pw.Close()
    }()
    return pr
}

func tail(in io.Reader, lines int) io.Reader {
    pr, pw := io.Pipe()
    go func() {
        if lines <= 0 {
            lines = 10
        }
        ring := make([]string, lines)
        rn := 0
        full := false
        bf := bufio.NewReader(in)
        var readErr error
        var s string
        for {
            s, readErr = bf.ReadString('\n')
            if readErr == nil {
                ring[rn] = s
                rn++
                if rn == lines {
                    rn = 0
                    full = true
                }
                continue
            }
            if readErr == io.EOF && s > "" {
                ring[rn] = s + "\n"
                rn++
            }
            break
        }
        writeLines := func(start, end int) {
            for i := start; i < end; i++ {
                if _, err := io.WriteString(pw, ring[i]); err != nil {
                    return
                }
            }
        }
        if full {
            writeLines(rn, lines)
        }
        writeLines(0, rn)
        pw.CloseWithError(readErr)
    }()
    return pr
}

func sortPipe(in io.Reader) io.Reader {
    pr, pw := io.Pipe()
    go func() {
        b, err := ioutil.ReadAll(in)
        if len(b) > 0 {
            if b[len(b)-1] == '\n' {
                b = b[:len(b)-1]
            }
            list := strings.Split(string(b), "\n")
            sort.Strings(list)
            for _, s := range list {
                if _, err := io.WriteString(pw, s+"\n"); err != nil {
                    return
                }
            }
        }
        pw.CloseWithError(err)
    }()
    return pr
}

func main() {
    fs["List_of_computer_scientists.lst"] =
        `Wil van der Aalst        business process management, process mining, Petri nets
Hal Abelson              intersection of computing and teaching
Serge Abiteboul          database theory
Samson Abramsky          game semantics
Leonard Adleman          RSA, DNA computing
Manindra Agrawal         polynomial-time primality testing
Luis von Ahn             human-based computation
Alfred Aho               compilers book, the 'a' in AWK
Stephen R. Bourne        Bourne shell, portable ALGOL 68C compiler
Kees Koster              ALGOL 68
Lambert Meertens         ALGOL 68, ABC (programming language)
Peter Naur               BNF, ALGOL 60
Guido van Rossum         Python (programming language)
Adriaan van Wijngaarden  Dutch pioneer; ARRA, ALGOL
Dennis E. Wisnosky       Integrated Computer-Aided Manufacturing (ICAM), IDEF
Stephen Wolfram          Mathematica
William Wulf             compilers
Edward Yourdon           Structured Systems Analysis and Design Method
Lotfi Zadeh              fuzzy logic
Arif Zaman               Pseudo-random number generator
Albert Zomaya            Australian pioneer of scheduling in parallel and distributed systems
Konrad Zuse              German pioneer of hardware and software
`
    toName("aa", grep(tee(uniq(sortPipe(io.MultiReader(
        head(fromName("List_of_computer_scientists.lst"), 4),
        tee(grep(fromName("List_of_computer_scientists.lst"), "ALGOL"),
            "ALGOL_pioneers.lst"),
        tail(fromName("List_of_computer_scientists.lst"), 4)))),
        "the_important_scientists.lst"), "aa"))

    fmt.Print("Pioneer: ", fs["aa"])
    showCount("Number of ALGOL pioneers", "ALGOL_pioneers.lst")
    showCount("Number of scientists", "the_important_scientists.lst")
}

func showCount(heading, name string) {
    if data, ok := fs[name]; ok {
        lines := strings.Split(data, "\n")
        n := len(lines)
        if lines[n-1] == "" {
            n--
        }
        fmt.Printf("%s: %v\n", heading, n)
    } else {
        fmt.Println(name, "not found")
    }
}
