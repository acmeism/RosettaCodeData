/* go run IRC_gateway.go */

package main

import (
    "bufio"
    "crypto/tls"
    "fmt"
    wren "github.com/crazyinfin8/WrenGo"
    "github.com/thoj/go-ircevent"
    "log"
    "os"
    "strings"
)

type any = interface{} // not needed if using Go v1.18 or later

var ircObjs [2]*irc.Connection

func newIRC(vm *wren.VM, parameters []any) (any, error) {
    number := int(parameters[1].(float64))
    nick := parameters[2].(string)
    user := parameters[3].(string)
    ircObjs[number] = irc.IRC(nick, user)
    return &ircObjs[number], nil
}

func connect(vm *wren.VM, parameters []any) (any, error) {
    handle := parameters[0].(*wren.ForeignHandle)
    ifc, _ := handle.Get()
    ircObj := *(ifc.(**irc.Connection))
    server := parameters[1].(string)
    err := ircObj.Connect(server)
    if err != nil {
        log.Fatal(err)
    }
    return nil, nil
}

func setVerboseCallbackHandler(vm *wren.VM, parameters []any) (any, error) {
    handle := parameters[0].(*wren.ForeignHandle)
    ifc, _ := handle.Get()
    ircObj := *(ifc.(**irc.Connection))
    value := parameters[1].(bool)
    ircObj.VerboseCallbackHandler = value
    return nil, nil
}

func setDebug(vm *wren.VM, parameters []any) (any, error) {
    handle := parameters[0].(*wren.ForeignHandle)
    ifc, _ := handle.Get()
    ircObj := *(ifc.(**irc.Connection))
    value := parameters[1].(bool)
    ircObj.Debug = value
    return nil, nil
}

func setUseTLS(vm *wren.VM, parameters []any) (any, error) {
    handle := parameters[0].(*wren.ForeignHandle)
    ifc, _ := handle.Get()
    ircObj := *(ifc.(**irc.Connection))
    value := parameters[1].(bool)
    ircObj.UseTLS = value
    return nil, nil
}

func setConfigTLS(vm *wren.VM, parameters []any) (any, error) {
    handle := parameters[0].(*wren.ForeignHandle)
    ifc, _ := handle.Get()
    ircObj := *(ifc.(**irc.Connection))
    value := parameters[1].(bool)
    ircObj.TLSConfig = &tls.Config{InsecureSkipVerify: value}
    return nil, nil
}

func addCallback(vm *wren.VM, parameters []any) (any, error) {
    handle := parameters[0].(*wren.ForeignHandle)
    ifc, _ := handle.Get()
    ircObj := *(ifc.(**irc.Connection))
    number := int(parameters[1].(float64))
    code := parameters[2].(string)
    msg := parameters[3].(string)
    channel := parameters[4].(string)
    nick := parameters[5].(string)
    otherNick := parameters[6].(string)
    if code == "001" {
        ircObj.AddCallback("001", func(e *irc.Event) {
            ircObj.Join(channel)
            ircObj.Privmsg(nick, msg)
            log.Println(msg)
        })
    } else if code == "366" {
        ircObj.AddCallback("366", func(e *irc.Event) {})
    } else if code == "PRIVMSG" {
        ircObj.AddCallback("PRIVMSG", func(e *irc.Event) {
            msg := fmt.Sprintf("<%s> %s", nick, e.Message)
            if number == 0 {
                ircObjs[1].Privmsg(otherNick, msg)
            } else {
                ircObjs[0].Privmsg(otherNick, msg)
            }
            log.Println(msg)
        })
    }
    return nil, nil
}

func newReader(vm *wren.VM, parameters []any) (any, error) {
    reader := bufio.NewReader(os.Stdin)
    return &reader, nil
}

func readLine(vm *wren.VM, parameters []any) (any, error) {
    handle := parameters[0].(*wren.ForeignHandle)
    ifc, _ := handle.Get()
    bufin := *(ifc.(**bufio.Reader))
    s, _ := bufin.ReadString('\n') // includes the delimiter
    return s[:len(s)-1], nil
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
    var fileName = "IRC_gateway.wren"
    IRCMethodMap := wren.MethodMap{
        "connect(_)":                 connect,
        "verboseCallbackHandler=(_)": setVerboseCallbackHandler,
        "debug=(_)":                  setDebug,
        "useTLS=(_)":                 setUseTLS,
        "configTLS=(_)":              setConfigTLS,
        "addCallback(_,_,_,_,_,_)":   addCallback,
    }

    readerMethodMap := wren.MethodMap{"readLine()": readLine}

    classMap := wren.ClassMap{
        "IRC":    wren.NewClass(newIRC, nil, IRCMethodMap),
        "Reader": wren.NewClass(newReader, nil, readerMethodMap),
    }

    module := wren.NewModule(classMap)
    vm.SetModule(fileName, module)
    vm.InterpretFile(fileName)
    go ircObjs[1].Loop()
    ircObjs[0].Loop()
    vm.Free()
}
