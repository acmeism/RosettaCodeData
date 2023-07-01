/* run_system_command.go*/
package main

import (
    wren "github.com/crazyinfin8/WrenGo"
    "log"
    "os"
    "os/exec"
)

type any = interface{}

func execCommand(vm *wren.VM, parameters []any) (any, error) {
    name := parameters[1].(string)
    param := parameters[2].(string)
    var cmd *exec.Cmd
    if param != "" {
        cmd = exec.Command(name, param)
    } else {
        cmd = exec.Command(name)
    }
    cmd.Stdout = os.Stdout
    cmd.Stderr = os.Stderr
    if err := cmd.Run(); err != nil {
        log.Fatal(err)
    }
    return nil, nil
}

func main() {
    vm := wren.NewVM()
    fileName := "run_system_command.wren"
    methodMap := wren.MethodMap{"static exec(_,_)": execCommand}
    classMap := wren.ClassMap{"Command": wren.NewClass(nil, nil, methodMap)}
    module := wren.NewModule(classMap)
    vm.SetModule(fileName, module)
    vm.InterpretFile(fileName)
    vm.Free()
}
