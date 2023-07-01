/* write_to_windows_event_log.wren */

class Windows {
    foreign static eventCreate(args)
}

var args = [
    "/T", "INFORMATION", "/ID", "123", "/L", "APPLICATION",
    "/SO", "Wren", "/D", "\"Rosetta Code Example\""
].join(" ")

Windows.eventCreate(args)
