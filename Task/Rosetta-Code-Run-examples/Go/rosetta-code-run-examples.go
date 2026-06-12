package main

import (
    "bufio"
    "fmt"
    "html"
    "io/ioutil"
    "log"
    "net/http"
    "os"
    "os/exec"
    "regexp"
    "strings"
)

func getAllTasks() map[string]bool {
    ex := `<li><a href="/wiki/(.*?)"`
    re := regexp.MustCompile(ex)
    url1 := "http://rosettacode.org/wiki/Category:Programming_Tasks"
    url2 := "http://rosettacode.org/wiki/Category:Draft_Programming_Tasks"
    urls := []string{url1, url2}
    tasks := make(map[string]bool)
    for _, url := range urls {
        resp, _ := http.Get(url)
        body, _ := ioutil.ReadAll(resp.Body)
        // find all tasks
        matches := re.FindAllStringSubmatch(string(body), -1)
        resp.Body.Close()
        for _, match := range matches {
            // exclude any 'category' references
            if !strings.HasPrefix(match[1], "Category:") {
                tasks[match[1]] = true
            }
        }
    }
    return tasks
}

func check(err error) {
    if err != nil {
        log.Fatal(err)
    }
}

func main() {
    tasks := getAllTasks()
    for {
        fmt.Print("Enter the exact name of the task  : ")
        in := bufio.NewReader(os.Stdin)
        task, err := in.ReadString('\n')
        check(err)
        task = strings.TrimSpace(task)
        task = strings.ReplaceAll(task, " ", "_")
        if !tasks[task] {
            fmt.Println("Sorry a task with that name doesn't exist.")
        } else {
            url := "https://rosettacode.org/mw/index.php?title=" + task + "&action=edit"
            resp, err := http.Get(url)
            check(err)
            body, _ := ioutil.ReadAll(resp.Body)
            resp.Body.Close()
            var lang string
            for {
                fmt.Print("Enter the language Go/Perl/Python : ")
                lang, err = in.ReadString('\n')
                check(err)
                lang = strings.TrimSpace(lang)
                lang = strings.ToLower(lang)
                if lang == "go" || lang == "perl" || lang == "python" {
                    break
                }
                fmt.Println("Sorry that language is not supported.")
            }
            var lang2, lang3, ext string
            switch lang {
            case "go":
                lang2 = "Go"
                lang3 = "(go|Go|GO)"
                ext = "go"
            case "perl":
                lang2 = "Perl"
                lang3 = "(perl|Perl)"
                ext = "pl"
            case "python":
                lang2 = "Python"
                lang3 = "(python|Python)"
                ext = "py"
            }
            fileName := "rc_temp." + ext
            header := fmt.Sprintf(`(?s)==\{\{header\|%s\}\}==.*?&lt;lang %s>`, lang2, lang3)
            exp := header + `(.*?)&lt;/lang>`
            re := regexp.MustCompile(exp)
            page := string(body)
            matches := re.FindStringSubmatch(page)
            if matches == nil {
                fmt.Println("No runnable task entry for that language was detected.")
            } else {
                source := html.UnescapeString(matches[2])
                fmt.Println("\nThis is the source code for the first or only runnable program:\n")
                fmt.Println(source)
                fmt.Print("\nDo you want to run it y/n : ")
                yn, err := in.ReadString('\n')
                check(err)
                if yn[0] == 'y' || yn[0] == 'Y' {
                    err = ioutil.WriteFile(fileName, []byte(source), 0666)
                    check(err)
                    var cmd *exec.Cmd
                    switch lang {
                    case "go":
                        cmd = exec.Command("go", "run", fileName)
                    case "perl":
                        cmd = exec.Command("perl", fileName)
                    case "python":
                        cmd = exec.Command("python3", fileName)
                    }
                    cmd.Stdout = os.Stdout
                    cmd.Stderr = os.Stderr
                    cmd.Run() // allow any error(s) to go to StdEerr
                    check(os.Remove(fileName))
                }
            }
            fmt.Print("\nDo another one y/n : ")
            yn, err := in.ReadString('\n')
            check(err)
            if yn[0] != 'y' &&  yn[0] != 'Y' {
                break
            }
        }
    }
}
