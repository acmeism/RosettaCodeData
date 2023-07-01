/* mac_vendor_lookup.go */
package main

import (
    wren "github.com/crazyinfin8/WrenGo"
    "io/ioutil"
    "net/http"
)

type any = interface{}

func macLookup(vm *wren.VM, parameters []any) (any, error) {
    mac := parameters[1].(string)
    resp, err := http.Get("http://api.macvendors.com/" + mac)
    if err != nil {
        return nil, nil
    }
    body, err := ioutil.ReadAll(resp.Body)
    if err != nil {
        return nil, nil
    }
    var vendor = string(body)
    if vendor == `{"errors":{"detail":"Not Found"}}` {
        return "N/A", nil
    }
    return vendor, nil
}

func main() {
    vm := wren.NewVM()
    fileName := "mac_vendor_lookup.wren"
    methodMap := wren.MethodMap{"static lookup(_)": macLookup}
    classMap := wren.ClassMap{"MAC": wren.NewClass(nil, nil, methodMap)}
    module := wren.NewModule(classMap)
    vm.SetModule(fileName, module)
    vm.InterpretFile(fileName)
    vm.Free()
}
