/* go build Use_a_REST_API.go */

package main

import (
    "github.com/Guitarbum722/meetup-client"
    "github.com/Guitarbum722/meetup-client/models"
    wren "github.com/crazyinfin8/WrenGo"
    "io/ioutil"
    "log"
    "net/url"
    "strings"
)

type any = interface{}

func eventOptions(et map[string][]string, vals url.Values) {
    for k, v := range et {
        if len(v) < 1 {
            break
        }
        switch k {
        case meetup.GroupID:
            vals.Add(meetup.GroupID, strings.Join(v, ","))
        case meetup.GroupURLName:
            vals.Add(meetup.GroupURLName, strings.Join(v, ","))
        case meetup.EventName:
            vals.Add(meetup.EventName, strings.Join(v, ","))
        case meetup.Description:
            vals.Add(meetup.Description, strings.Join(v, ","))
        case meetup.EventTime:
            vals.Add(meetup.EventTime, strings.Join(v, ","))
        default:
            // empty
        }
    }
}

func check(err error) {
    if err != nil {
        log.Fatal(err)
    }
}

func getKey(vm *wren.VM, parameters []any) (any, error) {
    keyFile := parameters[1].(string)
    keydata, err := ioutil.ReadFile(keyFile)
    check(err)
    key := strings.TrimSpace(string(keydata))
    return key, nil
}

func newClient(vm *wren.VM, parameters []any) (any, error) {
    key := parameters[1].(string)
    c := meetup.NewClient(&meetup.ClientOpts{APIKey: key})
    return &c, nil
}

func deleteEvent(vm *wren.VM, parameters []any) (any, error) {
    handle := parameters[0].(*wren.ForeignHandle)
    ifc, _ := handle.Get()
    c := ifc.(*meetup.Clienter)
    eventId := parameters[1].(string)
    err := (*c).DeleteEvent(eventId)
    check(err)
    return nil, nil
}

func newGroup(vm *wren.VM, parameters []any) (any, error) {
    handle := parameters[1].(*wren.ForeignHandle)
    ifc, _ := handle.Get()
    c := ifc.(*meetup.Clienter)
    urlName := parameters[2].(string)
    groups, err := (*c).GroupByURLName([]string{urlName})
    check(err)
    if len(groups.Groups) == 0 {
        log.Fatalf("There are no groups for the url name '%s'.\n", urlName)
    }
    return &(groups.Groups[0]), nil
}

func urlName(vm *wren.VM, parameters []any) (any, error) {
    handle := parameters[0].(*wren.ForeignHandle)
    ifc, _ := handle.Get()
    g := ifc.(**models.Group)
    return (**g).URLName, nil
}

func groupId(vm *wren.VM, parameters []any) (any, error) {
    handle := parameters[0].(*wren.ForeignHandle)
    ifc, _ := handle.Get()
    g := ifc.(**models.Group)
    return (**g).ID, nil
}

func memberCount(vm *wren.VM, parameters []any) (any, error) {
    handle := parameters[0].(*wren.ForeignHandle)
    ifc, _ := handle.Get()
    g := ifc.(**models.Group)
    return (**g).MemberCount, nil
}

func organizerName(vm *wren.VM, parameters []any) (any, error) {
    handle := parameters[0].(*wren.ForeignHandle)
    ifc, _ := handle.Get()
    g := ifc.(**models.Group)
    return (**g).Organizer.Name, nil
}

func newEvent(vm *wren.VM, parameters []any) (any, error) {
    handle := parameters[1].(*wren.ForeignHandle)
    ifc, _ := handle.Get()
    c := ifc.(*meetup.Clienter)
    mhandle := parameters[2].(*wren.MapHandle)
    o := make(map[string][]string)
    keys := []string{
        meetup.GroupID, meetup.GroupURLName, meetup.EventName,
        meetup.Description, meetup.EventTime,
    }
    for _, key := range keys {
        s, err := mhandle.Get(key)
        check(err)
        o[key] = []string{s.(string)}
    }
    event, err2 := (*c).CreateEvent(eventOptions, o)
    check(err2)
    return &event, nil
}

func eventId(vm *wren.VM, parameters []any) (any, error) {
    handle := parameters[0].(*wren.ForeignHandle)
    ifc, _ := handle.Get()
    event := ifc.(**models.Event)
    return (**event).ID, nil
}

func eventName(vm *wren.VM, parameters []any) (any, error) {
    handle := parameters[0].(*wren.ForeignHandle)
    ifc, _ := handle.Get()
    event := ifc.(**models.Event)
    return (**event).Name, nil
}

func newEvents(vm *wren.VM, parameters []any) (any, error) {
    handle := parameters[1].(*wren.ForeignHandle)
    ifc, _ := handle.Get()
    c := ifc.(*meetup.Clienter)
    urlName := parameters[2].(string)
    status := parameters[3].(string)
    desc := parameters[4].(bool)
    events, err := (*c).EventsByGroup(urlName, []string{status}, desc)
    check(err)
    return &events, nil
}

func eventsCount(vm *wren.VM, parameters []any) (any, error) {
    handle := parameters[0].(*wren.ForeignHandle)
    ifc, _ := handle.Get()
    events := ifc.(**models.Events)
    return len((**events).Events), nil
}

func eventsId(vm *wren.VM, parameters []any) (any, error) {
    handle := parameters[0].(*wren.ForeignHandle)
    ifc, _ := handle.Get()
    events := ifc.(**models.Events)
    index := int(parameters[1].(float64))
    return (**events).Events[index].ID, nil
}

func eventsName(vm *wren.VM, parameters []any) (any, error) {
    handle := parameters[0].(*wren.ForeignHandle)
    ifc, _ := handle.Get()
    events := ifc.(**models.Events)
    index := int(parameters[1].(float64))
    return (**events).Events[index].Name, nil
}

func eventsLink(vm *wren.VM, parameters []any) (any, error) {
    handle := parameters[0].(*wren.ForeignHandle)
    ifc, _ := handle.Get()
    events := ifc.(**models.Events)
    index := int(parameters[1].(float64))
    return (**events).Events[index].Link, nil
}

func venueName(vm *wren.VM, parameters []any) (any, error) {
    handle := parameters[0].(*wren.ForeignHandle)
    ifc, _ := handle.Get()
    events := ifc.(**models.Events)
    index := int(parameters[1].(float64))
    return (**events).Events[index].Venue.Name, nil
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

    meetupMethodMap := wren.MethodMap{
        "static getKey(_)": getKey,
    }

    clientMethodMap := wren.MethodMap{
        "deleteEvent(_)": deleteEvent,
    }

    groupMethodMap := wren.MethodMap{
        "urlName":       urlName,
        "groupId":       groupId,
        "memberCount":   memberCount,
        "organizerName": organizerName,
    }

    eventMethodMap := wren.MethodMap{
        "eventId":   eventId,
        "eventName": eventName,
    }

    eventsMethodMap := wren.MethodMap{
        "eventsCount":   eventsCount,
        "eventsId(_)":   eventsId,
        "eventsName(_)": eventsName,
        "eventsLink(_)": eventsLink,
        "venueName(_)":  venueName,
    }

    classMap := wren.ClassMap{
        "Meetup": wren.NewClass(nil, nil, meetupMethodMap),
        "Client": wren.NewClass(newClient, nil, clientMethodMap),
        "Group":  wren.NewClass(newGroup, nil, groupMethodMap),
        "Event":  wren.NewClass(newEvent, nil, eventMethodMap),
        "Events": wren.NewClass(newEvents, nil, eventsMethodMap),
    }

    module := wren.NewModule(classMap)
    fileName := "Use_a_REST_API.wren"
    vm.SetModule(fileName, module)
    vm.InterpretFile(fileName)
    vm.Free()
}
