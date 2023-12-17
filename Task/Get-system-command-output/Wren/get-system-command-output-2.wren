/* Get_system_command_output.go */
package main

import (
    wren "github.com/crazyinfin8/WrenGo"
    "log"
    "os"
    "os/exec"
)

type any = interface{}

func getCommandOutput(vm *wren.VM, parameters []any) (any, error) {
    name := parameters[1].(string)
    param := parameters[2].(string)
    var cmd *exec.Cmd
    if param != "" {
        cmd = exec.Command(name, param)
    } else {
        cmd = exec.Command(name)
    }
    cmd.Stderr = os.Stderr
    bytes, err := cmd.Output()
    if err != nil {
        log.Fatal(err)
    }
    return string(bytes), nil
}

func main() {
    vm := wren.NewVM()
    fileName := "Get_system_command_output.wren"
    methodMap := wren.MethodMap{"static output(_,_)": getCommandOutput}
    classMap := wren.ClassMap{"Command": wren.NewClass(nil, nil, methodMap)}
    module := wren.NewModule(classMap)
    vm.SetModule(fileName, module)
    vm.InterpretFile(fileName)
    vm.Free()
}
