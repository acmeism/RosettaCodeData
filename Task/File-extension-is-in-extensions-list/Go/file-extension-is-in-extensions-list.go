package main

import (
    "fmt"
    "strings"
)

var extensions = []string{"zip", "rar", "7z", "gz", "archive", "A##", "tar.bz2"}

func fileExtInList(filename string) (bool, string) {
    filename2 := strings.ToLower(filename)
    for _, ext := range extensions {
        ext2 := "." + strings.ToLower(ext)
        if strings.HasSuffix(filename2, ext2) {
            return true, ext
        }
    }
    s := strings.Split(filename, ".")
    if len(s) > 1 {
        t := s[len(s)-1]
        if t != "" {
            return false, t
        } else {
            return false, "<empty>"
        }
    } else {
        return false, "<none>"
    }
}

func main() {
    fmt.Println("The listed extensions are:")
    fmt.Println(extensions, "\n")
    tests := []string{
        "MyData.a##", "MyData.tar.Gz", "MyData.gzip",
        "MyData.7z.backup", "MyData...", "MyData",
        "MyData_v1.0.tar.bz2", "MyData_v1.0.bz2",
    }
    for _, test := range tests {
        ok, ext := fileExtInList(test)
        fmt.Printf("%-20s => %-5t  (extension = %s)\n", test, ok, ext)
    }
}
