using Dates, TimeZones, HTTP, Printf

function geturlbyday(n)
    d = DateTime(now(tz"Europe/Berlin")) + Day(n)  # n should be <= 0
    uri = @sprintf("http://tclers.tk/conferences/tcl/%04d-%02d-%02d.tcl",
        year(d), month(d), day(d))
    return uri, String(HTTP.request("GET", uri).body)
end

function searchlogs(text = ARGS[1], daysback = 9)
    for n in -daysback:0
        fname, searchtext = geturlbyday(n)
        println("$fname\n------")
        for line in split(searchtext, "\n")
            if findfirst(text, line) != nothing
                println(line)
            end
        end
        println("------\n")
    end
end

if length(ARGS) != 1
    println("Usage: type search phrase in quotes as an argument.")
else
    searchlogs()
end
