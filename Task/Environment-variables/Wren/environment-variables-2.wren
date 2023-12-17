/* Environment_variables.go */
package main

import (
    wren "github.com/crazyinfin8/WrenGo"
    "os"
)

type any = interface{}

func getEnvironVariable(vm *wren.VM, parameters []any) (any, error) {
    name := parameters[1].(string)
    return os.Getenv(name), nil
}

func main() {
    vm := wren.NewVM()
    fileName := "Environment_variables.wren"
    methodMap := wren.MethodMap{"static variable(_)": getEnvironVariable}
    classMap := wren.ClassMap{"Environ": wren.NewClass(nil, nil, methodMap)}
    module := wren.NewModule(classMap)
    vm.SetModule(fileName, module)
    vm.InterpretFile(fileName)
    vm.Free()
}
