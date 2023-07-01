package main

import (
    "io/ioutil"
    "log"
    "os"
    "os/exec"
    "strings"
)

func check(err error) {
    if err != nil {
        log.Fatal(err)
    }
}

func main() {
    lower := []string{
        "const ", "else ", "for ", "func ", "if ", "import ", "int ", "package ", "string ", "var ",
        " int", "int(", "string{", " main", "main(", "fmt", "time", "%d", "%s", "%3d", `d\n\n`, `s\n\n`,
    }
    title := []string{
        ".add", ".date", ".day", ".hour", ".month", ".printf", ".println", ".sprintf", ".weekday", ".year",
    }
    code, err := ioutil.ReadFile("realcal_UC.txt")
    check(err)
    text := string(code)
    for _, lwr := range lower {
        text = strings.Replace(text, strings.ToUpper(lwr), lwr, -1)
    }
    for _, ttl := range title {
        text = strings.Replace(text, strings.ToUpper(ttl), "."+strings.Title(ttl[1:]), -1)
    }
    err = ioutil.WriteFile("realcal_NC.go", []byte(text), 0666)
    check(err)
    cmd := exec.Command("go", "run", "realcal_NC.go")
    cmd.Stdout = os.Stdout
    cmd.Stderr = os.Stderr
    check(cmd.Run())
}
