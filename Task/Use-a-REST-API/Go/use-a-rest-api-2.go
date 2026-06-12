package main

import (
    "fmt"
    "github.com/Guitarbum722/meetup-client"
    "io/ioutil"
    "log"
    "net/url"
    "strconv"
    "strings"
    "time"
)

var key string

func init() {
    // Read an API key from the specified file.
    const keyFile = "api_key.txt"
    keydata, err := ioutil.ReadFile(keyFile)
    if err != nil {
        log.Fatal(err)
    }
    key = strings.TrimSpace(string(keydata))
}

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

func main() {
    // create client
    c := meetup.NewClient(&meetup.ClientOpts{APIKey: key})

    // get basic information for a particular group
    const urlName = "Meetup-API-Testing"
    groups, err := c.GroupByURLName([]string{urlName})
    check(err)
    g := groups.Groups[0]
    fmt.Printf("Basic information for the %q group:\n", g.URLName)
    fmt.Printf("  ID           : %d\n", g.ID)
    fmt.Printf("  Member count : %d\n", g.MemberCount)
    fmt.Printf("  Organizer    : %s\n", g.Organizer.Name)
    fmt.Println()

    // get a list of upcoming events for this group
    events, err := c.EventsByGroup(urlName, []string{meetup.EventUpcoming}, false)
    check(err)
    for _, event := range events.Events {
        fmt.Printf("Upcoming events for the %q group\n", g.URLName)
        fmt.Printf("  ID    : %s\n", event.ID)
        fmt.Printf("  Name  : %s\n", event.Name)
        fmt.Printf("  Link  : %s\n", event.Link)
        fmt.Printf("  Venue : %s\n", event.Venue.Name)
        fmt.Println()
    }

    // create an event for this group
    d := time.Date(2020, time.April, 1, 18, 0, 0, 0, time.UTC)
    eventDate := strconv.FormatInt((d.UnixNano() / 1000000), 10)
    event, err := c.CreateEvent(eventOptions, map[string][]string{
        meetup.GroupID:      {strconv.Itoa(g.ID)},
        meetup.GroupURLName: {urlName},
        meetup.EventName:    {"Test Meetup integration"},
        meetup.Description:  {"This is an event test."},
        meetup.EventTime:    {eventDate},
    })
    check(err)
    fmt.Printf("The ID for the %q event is %s\n\n", event.Name, event.ID)

    // delete the event just posted
    err = c.DeleteEvent(event.ID)
    check(err)
    fmt.Printf("The %q event has been cancelled.\n", event.Name)
}
