/* go run Distributed_programming_client.go */

package main

import(
    wren "github.com/crazyinfin8/WrenGo"
    "log"
    "net/rpc"
    "strings"
)

type any = interface{}

func dialHTTP(vm *wren.VM, parameters []any) (any, error) {
    network := parameters[1].(string)
    address := parameters[2].(string)
    client, err := rpc.DialHTTP(network, address)
    if err != nil {
        log.Fatal(err)
    }
    return &client, nil
}

func call(vm *wren.VM, parameters []any) (any, error) {
    handle := parameters[0].(*wren.ForeignHandle)
    ifc, _ := handle.Get()
    client := ifc.(**rpc.Client)
    serviceMethod := parameters[1].(string)
    amount := parameters[2].(float64)
    var tax float64
    err := (*client).Call(serviceMethod, amount, &tax)
    if err != nil {
        log.Fatal(err)
    }
    return tax, nil
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
    fileName := "Distributed_programming_client.wren"
    clientMethodMap := wren.MethodMap { "call(_,_)": call }
    classMap := wren.ClassMap { "Client": wren.NewClass(dialHTTP, nil, clientMethodMap) }
    module := wren.NewModule(classMap)
    vm.SetModule(fileName, module)
    vm.InterpretFile(fileName)
    vm.Free()
}
