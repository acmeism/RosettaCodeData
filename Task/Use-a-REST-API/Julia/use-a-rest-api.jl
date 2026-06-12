using HTTP
using JSON

function meetup()
    # Read API key from file
    key = strip(String(read("api_key.txt")))
    url = "https://api.meetup.com"

    function composeURL(root::String, params::Dict)
        # Convert params to query string
        query = join(["$k=$(JSON.json(v))" for (k, v) in params], "&")
        return "$root?$query"
    end

    function get(params::Dict, callback::Function, path::String="/2/open_events")
        params_copy = copy(params)
        params_copy["key"] = key

        try
            response = HTTP.get(composeURL(url * path, params_copy))
            body = String(response.body)
            results = JSON.parse(body)["results"]
            callback(results)
        catch e
            println(stderr, "Error: ", e)
            return false
        end
    end

    function post(details::Dict, callback::Function, path::String="/2/event")
        details_copy = copy(details)
        details_copy["key"] = key

        try
            response = HTTP.post(
                url * path,
                ["Content-Type" => "application/x-www-form-urlencoded"],
                HTTP.Form(details_copy)
            )
            body = String(response.body)
            callback(body)
        catch e
            println(stderr, "Error: ", e)
        end
    end

    function parseEvent(mEvent::Dict)
        # Extract fields with default empty strings
        name = get(mEvent, "name", "")
        desc = get(mEvent, "description", "")
        url_event = get(mEvent, "event_url", "")
        city = haskey(mEvent, "venue") ? get(mEvent["venue"], "city", "") : ""
        lat = haskey(mEvent, "venue") ? get(mEvent["venue"], "lat", "") : ""
        lon = haskey(mEvent, "venue") ? get(mEvent["venue"], "lon", "") : ""
        group = haskey(mEvent, "group") ? get(mEvent["group"], "name", "") : ""

        # Build formatted string
        parsed = ""
        if !isempty(name) parsed *= "Name: $name\n" end
        if !isempty(desc) parsed *= "Description: $desc\n" end
        if !isempty(url_event) parsed *= "Url: $url_event\n" end
        if !isempty(city) parsed *= "City: $city\n" end
        if !isempty(lat) parsed *= "Latitude: $lat\n" end
        if !isempty(lon) parsed *= "Longitude: $lon\n" end
        if !isempty(group) parsed *= "Group: $group\n" end

        return parsed
    end

    function parseEvents(results::Vector)
        println("a")
        for event in results
            println(parseEvent(event))
        end
    end

    return (get=get, parseEvents=parseEvents, post=post)
end

# Example usage: Get events
const m = meetup()
m.get(
    Dict("topic" => "photo", "city" => "nyc"),
    results -> m.parseEvents(results)
)

# Example usage: Get group ID
m.get(
    Dict("group_urlname" => "foodie-programmers"),
    group -> println(group[1]["id"]),
    "/2/groups"
)

# Example usage: Post venue
m.post(
    Dict(
        "name" => "Finding Nemo",
        "address_1" => "p sherman 42 wallaby way sydney",
        "city" => "sydney",
        "country" => "australia"
    ),
    venue -> println("Venue: ", JSON.parse(venue), get(JSON.parse(venue), "id", "")),
    "/foodie-programmers/venues"
)

# Example usage: Post event
m.post(
    Dict(
        "group_id" => 42,
        "group_urlname" => "foodie-programmers",
        "name" => "Tomato Python Fest",
        "description" => "Code vegetables in Python! Special speech by Guido Van Rossum",
        "duration" => 1000 * 60 * 60 * 2,
        "time" => 1419879086343,
        "why" => "We should do this because... Less than 250 characters",
        "hosts" => "up to 5 comma separated member ids",
        "venue_id" => 42,
        "lat" => 42,
        "lon" => 42,
        "simple_html_description" => "Event description in <b>simple html</b>. Less than <i>50000</i> characters."
    ),
    result -> println("Event: ", result)
)
