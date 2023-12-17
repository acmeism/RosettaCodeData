/* go run DNS_query.go */

package main

import(
    wren "github.com/crazyinfin8/WrenGo"
    "net"
    "strings"
)

type any = interface{}

func lookupHost(vm *wren.VM, parameters []any) (any, error) {
    host := parameters[1].(string)
    addrs, err := net.LookupHost(host)
    if err != nil {
        return nil, nil
    }
    return strings.Join(addrs, ", "), nil
}

func main() {
    vm := wren.NewVM()
    fileName := "DNS_query.wren"
    methodMap := wren.MethodMap{"static lookupHost(_)": lookupHost}
    classMap := wren.ClassMap{"Net": wren.NewClass(nil, nil, methodMap)}
    module := wren.NewModule(classMap)
    vm.SetModule(fileName, module)
    vm.InterpretFile(fileName)
    vm.Free()
}
