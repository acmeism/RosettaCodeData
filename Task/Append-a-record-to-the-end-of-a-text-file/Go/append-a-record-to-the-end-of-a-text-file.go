package main

import (
    "bytes"
    "fmt"
    "io"
    "io/ioutil"
    "os"
)

type pw struct {
    account, password string
    uid, gid          uint
    gecos
    directory, shell string
}

type gecos struct {
    fullname, office, extension, homephone, email string
}

func (p *pw) encode(w io.Writer) (int, error) {
    return fmt.Fprintf(w, "%s:%s:%d:%d:%s,%s,%s,%s,%s:%s:%s\n",
        p.account, p.password, p.uid, p.gid,
        p.fullname, p.office, p.extension, p.homephone, p.email,
        p.directory, p.shell)
}

// data cut and pasted from task description
var p2 = []pw{
    {"jsmith", "x", 1001, 1000, gecos{"Joe Smith", "Room 1007",
        "(234)555-8917", "(234)555-0077", "jsmith@rosettacode.org"},
        "/home/jsmith", "/bin/bash"},
    {"jdoe", "x", 1002, 1000, gecos{"Jane Doe", "Room 1004",
        "(234)555-8914", "(234)555-0044", "jdoe@rosettacode.org"},
        "/home/jsmith", "/bin/bash"},
}

var pa = pw{"xyz", "x", 1003, 1000, gecos{"X Yz", "Room 1003",
    "(234)555-8913", "(234)555-0033", "xyz@rosettacode.org"},
    "/home/xyz", "/bin/bash"}

var expected = "xyz:x:1003:1000:X Yz,Room 1003,(234)555-8913," +
    "(234)555-0033,xyz@rosettacode.org:/home/xyz:/bin/bash"

const pfn = "mythical"

func main() {
    writeTwo()
    appendOneMore()
    checkResult()
}

func writeTwo() {
    // overwrites any existing file
    f, err := os.Create(pfn)
    if err != nil {
        fmt.Println(err)
        return
    }
    defer func() {
        if cErr := f.Close(); cErr != nil && err == nil {
            fmt.Println(cErr)
        }
    }()
    for _, p := range p2 {
        if _, err = p.encode(f); err != nil {
            fmt.Println(err)
            return
        }
    }
}

func appendOneMore() {
    // file must already exist
    f, err := os.OpenFile(pfn, os.O_RDWR|os.O_APPEND, 0)
    if err != nil {
        fmt.Println(err)
        return
    }
    if _, err := pa.encode(f); err != nil {
        fmt.Println(err)
    }
    if cErr := f.Close(); cErr != nil && err == nil {
        fmt.Println(cErr)
    }
}

func checkResult() {
    // reads entire file then closes it
    b, err := ioutil.ReadFile(pfn)
    if err != nil {
        fmt.Println(err)
        return
    }
    if string(bytes.Split(b, []byte{'\n'})[2]) == expected {
        fmt.Println("append okay")
    } else {
        fmt.Println("it didn't work")
    }
}
