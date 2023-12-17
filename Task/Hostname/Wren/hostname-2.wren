/* Hostname.go */
package main

import (
    wren "github.com/crazyinfin8/WrenGo"
    "os"
)

type any = interface{}

func hostname(vm *wren.VM, parameters []any) (any, error) {
    name, _ := os.Hostname()
    return name, nil
}

func main() {
    vm := wren.NewVM()
    fileName := "Hostname.wren"
    methodMap := wren.MethodMap{"static name()": hostname}
    classMap := wren.ClassMap{"Host": wren.NewClass(nil, nil, methodMap)}
    module := wren.NewModule(classMap)
    vm.SetModule(fileName, module)
    vm.InterpretFile(fileName)
    vm.Free()
}
