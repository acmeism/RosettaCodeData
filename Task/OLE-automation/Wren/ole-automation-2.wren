/* go run OLE_automation.go */

package main

import (
    ole "github.com/go-ole/go-ole"
    "github.com/go-ole/go-ole/oleutil"
    "strings"
    "time"
    wren "github.com/crazyinfin8/WrenGo"
)

type any = interface{}

var dispMap = make(map[string]*ole.IDispatch)

func coInitialize(vm *wren.VM, parameters []any) (any, error) {
    p := uintptr(parameters[1].(float64))
    ole.CoInitialize(p)
    return nil, nil
}

func coUninitialize(vm *wren.VM, parameters []any) (any, error) {
    ole.CoUninitialize()
    return nil, nil
}

func putProperty(vm *wren.VM, parameters []any) (any, error) {
    disp := dispMap[parameters[1].(string)]
    propName := parameters[2].(string)
    param := parameters[3]
    oleutil.PutProperty(disp, propName, param)
    return nil, nil
}

func mustGetProperty(vm *wren.VM, parameters []any) (any, error) {
    disp := dispMap[parameters[1].(string)]
    propName := parameters[2].(string)
    disp2 := oleutil.MustGetProperty(disp, propName).ToIDispatch()
    disp2Name := strings.ToLower(propName)
    dispMap[disp2Name] = disp2
    return disp2Name, nil
}

func mustCallMethod(vm *wren.VM, parameters []any) (any, error) {
    dispName := parameters[1].(string)
    disp := dispMap[dispName]
    methName := parameters[2].(string)
    disp2 := oleutil.MustCallMethod(disp, methName).ToIDispatch()
    disp2Name := dispName[0:len(dispName)-1]
    dispMap[disp2Name] = disp2
    return disp2Name, nil
}

func mustCallMethod2(vm *wren.VM, parameters []any) (any, error) {
    dispName := parameters[1].(string)
    disp := dispMap[dispName]
    methName := parameters[2].(string)
    param := parameters[3]
    disp2 := oleutil.MustCallMethod(disp, methName, param).ToIDispatch()
    disp2Name := dispName[0:len(dispName)-1]
    dispMap[disp2Name] = disp2
    return disp2Name, nil
}

func newGUID(vm *wren.VM, parameters []any) (any, error) {
    param := parameters[1].(string)
    guid := ole.NewGUID(param)
    return &guid, nil
}

func newIUnknown(vm *wren.VM, parameters []any) (any, error) {
    programID := parameters[1].(string)
    unknown, _ := oleutil.CreateObject(programID)
    return &unknown, nil
}

func queryInterface(vm *wren.VM, parameters []any) (any, error) {
    handle  := parameters[0].(*wren.ForeignHandle)
    ifc, _  := handle.Get()
    unknown := ifc.(**ole.IUnknown)
    handle2 := parameters[1].(*wren.ForeignHandle)
    ifc2, _ := handle2.Get()
    guid    := ifc2.(**ole.GUID)
    disp, _ := (*unknown).QueryInterface(*guid)
    name    := parameters[2].(string)
    dispMap[name] = disp
    return name, nil
}

func release(vm *wren.VM, parameters []any) (any, error) {
    unknown := dispMap[parameters[1].(string)]
    unknown.Release()
    return nil, nil
}

func sleep(vm *wren.VM, parameters []any) (any, error) {
    secs := time.Duration(parameters[1].(float64))
    time.Sleep(secs * time.Second)
    return nil, nil
}

func main() {
    vm := wren.NewVM()
    fileName := "OLE_automation.wren"

    oleMethodMap := wren.MethodMap {
        "static coInitialize(_)" : coInitialize,
        "static coUninitialize()": coUninitialize,
    }

    oleUtilMethodMap := wren.MethodMap {
        "static putProperty(_,_,_)"    : putProperty,
        "static mustGetProperty(_,_)"  : mustGetProperty,
        "static mustCallMethod(_,_)"   : mustCallMethod,
        "static mustCallMethod2(_,_,_)": mustCallMethod2,
    }

    iUnknownMethodMap := wren.MethodMap {
        "queryInterface(_,_)": queryInterface,
        "static release(_)"  : release,
    }

    timeMethodMap := wren.MethodMap {
	"static sleep(_)": sleep,
    }

    classMap := wren.ClassMap {
        "Ole"      : wren.NewClass(nil, nil, oleMethodMap),
        "OleUtil"  : wren.NewClass(nil, nil, oleUtilMethodMap),
        "GUID"     : wren.NewClass(newGUID, nil, nil),
        "IUnknown" : wren.NewClass(newIUnknown, nil, iUnknownMethodMap),
        "Time"     : wren.NewClass(nil, nil, timeMethodMap),
    }

    module := wren.NewModule(classMap)
    vm.SetModule(fileName, module)
    vm.InterpretFile(fileName)
    vm.Free()
}
