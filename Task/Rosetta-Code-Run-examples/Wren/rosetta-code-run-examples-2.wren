/* go run Rosetta_Code_Run_examples.go  */

package main

import (
    "bufio"
    wren "github.com/crazyinfin8/WrenGo"
    "html"
    "io/ioutil"
    "log"
    "net/http"
    "os"
    "os/exec"
    "strings"
)

type any = interface{}

var in = bufio.NewReader(os.Stdin)

func check(err error) {
    if err != nil {
        log.Fatal(err)
    }
}

func getBodyText(vm *wren.VM, parameters []any) (any, error) {
    url := parameters[1].(string)
    resp, _ := http.Get(url)
    body, _ := ioutil.ReadAll(resp.Body)
    resp.Body.Close()
    return string(body), nil
}

func unescapeString(vm *wren.VM, parameters []any) (any, error) {
    s := parameters[1].(string)
    return html.UnescapeString(s), nil
}

func readLine(vm *wren.VM, parameters []any) (any, error) {
    l, err := in.ReadString('\n')
    check(err)
    return l, nil
}

func writeFile(vm *wren.VM, parameters []any) (any, error) {
    fileName := parameters[1].(string)
    text := parameters[2].(string)
    err := ioutil.WriteFile(fileName, []byte(text), 0666)
    check(err)
    return nil, nil
}

func removeFile(vm *wren.VM, parameters []any) (any, error) {
    fileName := parameters[1].(string)
    err := os.Remove(fileName)
    check(err)
    return nil, nil
}

func run2(vm *wren.VM, parameters []any) (any, error) {
    lang := parameters[1].(string)
    fileName := parameters[2].(string)
    cmd := exec.Command(lang, fileName)
    cmd.Stdout = os.Stdout
    cmd.Stderr = os.Stderr
    cmd.Run()
    return nil, nil
}

func run3(vm *wren.VM, parameters []any) (any, error) {
    lang := parameters[1].(string)
    param := parameters[2].(string)
    fileName := parameters[3].(string)
    cmd := exec.Command(lang, param, fileName)
    cmd.Stdout = os.Stdout
    cmd.Stderr = os.Stderr
    cmd.Run()
    return nil, nil
}

func moduleFn(vm *wren.VM, name string) (string, bool) {
    if name != "meta" && name != "random" && !strings.HasSuffix(name, ".wren") {
        name += ".wren"
    }
    return wren.DefaultModuleLoader(vm, name)
}

func main() {
    cfg := wren.NewConfig()
    cfg.LoadModuleFn = moduleFn
    vm := cfg.NewVM()

    httpMethodMap := wren.MethodMap{
        "static getBodyText(_)": getBodyText,
    }

    htmlMethodMap := wren.MethodMap{
        "static unescapeString(_)": unescapeString,
    }

    stdinMethodMap := wren.MethodMap{
        "static readLine()": readLine,
    }

    ioutilMethodMap := wren.MethodMap{
        "static writeFile(_,_)": writeFile,
        "static removeFile(_)":  removeFile,
    }

    execMethodMap := wren.MethodMap{
        "static run2(_,_)":   run2,
        "static run3(_,_,_)": run3,
    }

    classMap := wren.ClassMap{
        "Http":   wren.NewClass(nil, nil, httpMethodMap),
        "Html":   wren.NewClass(nil, nil, htmlMethodMap),
        "Stdin":  wren.NewClass(nil, nil, stdinMethodMap),
        "IOUtil": wren.NewClass(nil, nil, ioutilMethodMap),
        "Exec":   wren.NewClass(nil, nil, execMethodMap),
    }

    module := wren.NewModule(classMap)
    fileName := "Rosetta_Code_Run_examples.wren"
    vm.SetModule(fileName, module)
    vm.InterpretFile(fileName)
    vm.Free()
}
