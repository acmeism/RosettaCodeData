/* go build URL_shortener.go */

package main

import (
    "fmt"
    wren "github.com/crazyinfin8/WrenGo"
    "io/ioutil"
    "log"
    "net/http"
    "strings"
)

type any = interface{}

var fileName = "URL_shortener.wren"
var host = "localhost:8000"

var vm *wren.VM

var gw http.ResponseWriter
var greq *http.Request

func serveHTTP(w http.ResponseWriter, req *http.Request) {
    gw, greq = w, req
    wrenVar, _ := vm.GetVariable(fileName, "Http")
    wrenClass, _ := wrenVar.(*wren.Handle)
    defer wrenClass.Free()
    wrenMethod, _ := wrenClass.Func("serve()")
    defer wrenMethod.Free()
    wrenMethod.Call()
}

func writeHeader(vm *wren.VM, parameters []any) (any, error) {
    statusCode := int(parameters[1].(float64))
    gw.WriteHeader(statusCode)
    return nil, nil
}

func fprint(vm *wren.VM, parameters []any) (any, error) {
    str := parameters[1].(string)
    fmt.Fprintf(gw, str)
    return nil, nil
}

func method(vm *wren.VM, parameters []any) (any, error) {
    res := greq.Method
    return res, nil
}

func body(vm *wren.VM, parameters []any) (any, error) {
    res, _ := ioutil.ReadAll(greq.Body)
    return res, nil
}

func urlPath(vm *wren.VM, parameters []any) (any, error) {
    res := greq.URL.Path
    return res, nil
}

func getHost(vm *wren.VM, parameters []any) (any, error) {
    return host, nil
}

func redirect(vm *wren.VM, parameters []any) (any, error) {
    url := parameters[1].(string)
    code := int(parameters[2].(float64))
    http.Redirect(gw, greq, url, code)
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
    vm = cfg.NewVM()

    responseWriterMethodMap := wren.MethodMap{
        "static writeHeader(_)": writeHeader,
        "static fprint(_)":      fprint,
    }

    requestMethodMap := wren.MethodMap{
        "static method":  method,
        "static body":    body,
        "static urlPath": urlPath,
    }

    httpMethodMap := wren.MethodMap{
        "static host":          getHost,
        "static redirect(_,_)": redirect,
    }

    classMap := wren.ClassMap{
        "ResponseWriter": wren.NewClass(nil, nil, responseWriterMethodMap),
        "Request":        wren.NewClass(nil, nil, requestMethodMap),
        "Http":           wren.NewClass(nil, nil, httpMethodMap),
    }

    module := wren.NewModule(classMap)
    vm.SetModule(fileName, module)
    vm.InterpretFile(fileName)
    http.HandleFunc("/", serveHTTP)
    log.Fatal(http.ListenAndServe(host, nil))
    vm.Free()
}
