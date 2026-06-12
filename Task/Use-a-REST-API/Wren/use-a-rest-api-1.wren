/* Use_a_REST_API.wren */

import "./date" for Date

class Meetup {
    static groupId       { "group_id" }
    static groupUrlName  { "group_urlname" }
    static eventName     { "name" }
    static description   { "description" }
    static eventTime     { "time" }
    static eventUpcoming { "upcoming" }

    foreign static getKey(fileName)
}

foreign class Client {
    construct new(clientOpts) {}

    groupByUrlName(urlName) { Group.new(this, urlName) }

    eventsByGroup(urlName, status, desc)  { Events.new(this, urlName, status, desc) }

    createEvent(o) { Event.new(this, o) }

    foreign deleteEvent(eventId)
}

foreign class Group {
    construct new(client, urlName) {}

    foreign urlName
    foreign groupId
    foreign memberCount
    foreign organizerName
}

foreign class Event {
    construct new(client, o) {}

    foreign eventName
    foreign eventId
}

foreign class Events {
    construct new(client, urlName, status, desc) {}

    foreign eventsCount
    foreign eventsId(index)
    foreign eventsName(index)
    foreign eventsLink(index)
    foreign venueName(index)
}

var keyFile = "api_key.txt"
var key = Meetup.getKey(keyFile)
var c = Client.new(key)

// get basic information for a particular group
var urlName = "Meetup-API-Testing"
var g = c.groupByUrlName(urlName)
System.print("Basic information for the %(g.urlName) group:")
System.print("  ID           : %(g.groupId)")
System.print("  Member count : %(g.memberCount)")
System.print("  Organizer    : %(g.organizerName)")

// get a list of upcoming events for this group
var events = c.eventsByGroup(urlName, Meetup.eventUpcoming, false)
System.print("Upcoming events for the %(g.urlName) group")
for (i in 0...events.eventsCount) {
    System.print("  ID    : %(events.eventsId(i))")
    System.print("  Name  : %(events.eventsName(i))")
    System.print("  Link  : %(events.eventsLink(i))")
    System.print("  Venue : %(events.venueName(i))")
    System.print()
}

// create an event for this group
var eventDate = (Date.new(2022, 4, 1, 18, 0, 0, 0, "UTC").unixTime * 1000).toString
var o = {
    Meetup.groupId:      g.groupId.toString,
    Meetup.groupUrlName: urlName,
    Meetup.eventName:    "Test Meetup integration",
    Meetup.description:  "This is an event test.",
    Meetup.eventTime:    eventDate
}

var event = c.createEvent(o)
System.print("The ID for the %(event.eventName) event is %(event.eventId)\n")

// delete the event just posted
c.deleteEvent(event.eventId)
System.print("The %(event.eventName) event has been cancelled.\n")
