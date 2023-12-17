/* go run Distributed_programming_server.go */

package main

import(
    wren "github.com/crazyinfin8/WrenGo"
    "log"
    "net"
    "net/http"
    "net/rpc"
)

type any = interface{}

type TaxComputer float64

var vm2 *wren.VM

var fileName  = "Distributed_programming_server.wren"
var fileName2 = "Distributed_programming_server_2.wren"

func (taxRate TaxComputer) Tax(x float64, r *float64) error {
    wrenVar, _ := vm2.GetVariable(fileName2, "TaxComputer")
    wrenClass, _ := wrenVar.(*wren.Handle)
    defer wrenClass.Free()
    wrenMethod, _ := wrenClass.Func("tax(_,_)")
    defer wrenMethod.Free()
    ret, _ := wrenMethod.Call(x, float64(taxRate))
    *r = ret.(float64)
    return nil
}

func register(vm *wren.VM, parameters []any) (any, error) {
    c := TaxComputer(0.05) // 5% tax rate
    rpc.Register(c)
    return nil, nil
}

func handleHTTP(vm *wren.VM, parameters []any) (any, error) {
    rpc.HandleHTTP()
    return nil, nil
}

func serve(vm *wren.VM, parameters []any) (any, error) {
    handle := parameters[1].(*wren.ForeignHandle)
    ifc, _ := handle.Get()
    listener := ifc.(*net.Listener)
    http.Serve(*listener, nil)
    return nil, nil
}

func listen(vm *wren.VM, parameters []any) (any, error) {
    network := parameters[1].(string)
    address := parameters[2].(string)
    listener, err := net.Listen(network, address)
    if err != nil {
        log.Fatal(err)
    }
    return &listener, nil
}

func main() {
    vm := wren.NewVM()
    vm2 = wren.NewVM()
    vm2.InterpretFile(fileName2)

    rpcMethodMap := wren.MethodMap {
        "static register()": register,
        "static handleHTTP()": handleHTTP,
    }

    httpMethodMap := wren.MethodMap { "static serve(_)":serve }

    classMap := wren.ClassMap {
        "Listener": wren.NewClass(listen, nil, nil),
        "Rpc"     : wren.NewClass(nil, nil, rpcMethodMap),
        "HTTP"    : wren.NewClass(nil, nil, httpMethodMap),
    }

    module := wren.NewModule(classMap)
    vm.SetModule(fileName, module)
    vm.InterpretFile(fileName)
    vm.Free()
    vm2.Free()
}
