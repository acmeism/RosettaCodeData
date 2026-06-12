package main

import (
    "fmt"
    "io/ioutil"
    "os"
)

func main() {
    fn := "myth"
    bx := ".backup"
    // see if it's a link
    var err error
    if tf, err := os.Readlink(fn); err == nil {
        fn = tf
    }
    // stat to preserve permissions.
    var fi os.FileInfo
    if fi, err = os.Stat(fn); err != nil {
        fmt.Println(err)
        return
    }
    // attemp rename
    if err = os.Rename(fn, fn+bx); err != nil {
        fmt.Println(err)
        return
    }
    // create new file
    err = ioutil.WriteFile(fn, []byte("you too!\n"), fi.Mode().Perm())
    if err != nil {
        fmt.Println(err)
    }
}
