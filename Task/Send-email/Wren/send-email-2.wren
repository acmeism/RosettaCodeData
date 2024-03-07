/* go run Send_email.go */

package main

import(
    wren "github.com/crazyinfin8/WrenGo"
    "log"
    "bufio"
    "net/smtp"
    "os"
)

type any = interface{}

func sendMail(vm *wren.VM, parameters []any) (any, error) {
    address := parameters[1].(string)
    handle  := parameters[2].(*wren.ForeignHandle)
    ifc, _  := handle.Get()
    auth    := ifc.(*smtp.Auth)
    from    := parameters[3].(string)
    handle2 := parameters[4].(*wren.ListHandle)
    le, _   := handle2.Count()
    to      := make([]string, le)
    for i := 0; i < le; i++ {
        ifc2, _ := handle2.Get(i)
        to[i] = ifc2.(string)
    }
    msg := parameters[5].(string)
    err := smtp.SendMail(address, *auth, from, to, []byte(msg))
    if err != nil {
        log.Fatal(err)
    }
    return nil, nil
}

func plainAuth(vm *wren.VM, parameters []any) (any, error) {
    identity := parameters[1].(string)
    username := parameters[2].(string)
    password := parameters[3].(string)
    host     := parameters[4].(string)
    auth     := smtp.PlainAuth(identity, username, password, host)
    return &auth, nil
}

func newReader(vm *wren.VM, parameters []any) (any, error) {
    reader := bufio.NewReader(os.Stdin)
    return &reader, nil
}

func readString(vm *wren.VM, parameters []any) (any, error) {
    handle := parameters[0].(*wren.ForeignHandle)
    ifc, _ := handle.Get()
    bufin := ifc.(**bufio.Reader)
    delim := byte(parameters[1].(float64))
    s, _ := (*bufin).ReadString(delim)
    return s, nil
}

func main() {
    vm := wren.NewVM()
    fileName := "Send_email.wren"

    smtpMethodMap   := wren.MethodMap { "static sendMail(_,_,_,_,_)": sendMail }
    readerMethodMap := wren.MethodMap { "readString(_)": readString }

    classMap := wren.ClassMap {
        "Authority": wren.NewClass(plainAuth, nil, nil),
        "SMTP"     : wren.NewClass(nil, nil, smtpMethodMap),
        "Reader"   : wren.NewClass(newReader, nil, readerMethodMap),
    }

    module := wren.NewModule(classMap)
    vm.SetModule(fileName, module)
    vm.InterpretFile(fileName)
    vm.Free()
}
