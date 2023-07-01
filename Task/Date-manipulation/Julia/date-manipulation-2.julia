using Dates, TimeZones

function testdateparse()
    tzabbrev = Dict("EST" => "+0500", "CST" => "+0600", "MST" => "+0700",  "PST" => "+0800")
    dtstr = "March 7 2009 7:30pm EST"
    for (k, v) in tzabbrev
        dtstr = replace(dtstr, k => v)
    end
    dtformat = dateformat"U dd yyyy HH:MMp zzzzz"
    dtime = TimeZones.parse(ZonedDateTime, dtstr, dtformat)
    println(Dates.format(dtime, dtformat))
end

testdateparse()
