using Dates

"""
    nauticalbells(DateTime)

    Return a string according to the "simpler system" of nautical bells
    listed in the table in Wikipedia at
    en.wikipedia.org/wiki/Ship%27s_bell#Simpler_system.
    Note the traditional time zone was determined by local sun position
    and so should be local time without daylight savings time.
"""
function nauticalbells(dt::DateTime)
    hr = hour(dt)
    mn = minute(dt)
    if hr in [00, 12, 4, 8, 16, 20]
        return mn == 00 ? "2 2 2 2" : "1"
    elseif hr in [1, 5, 9, 13, 17, 21]
        return  mn == 00 ? "2" : "2 1"
    elseif hr in [2, 6, 10, 14, 18, 22]
        return mn == 00 ? "2 2" : "2 2 1"
    elseif hr in [3, 7, 11, 15, 19, 23]
        return mn == 00 ? "2 2 2" : "2 2 2 1"
    else
        return "Gong pattern error: time $dt, hour $hr, minutes $mn"
    end
end

function nauticalbelltask()
    untilnextbell = ceil(now(), Dates.Minute(30)) - now()
    delay = untilnextbell.value / 1000
    println("Nautical bell task starting -- next bell in $delay seconds.")
    # The timer wakes its task every half hour. May drift very slightly so restart yearly.
    timer = Timer(delay; interval=1800)
    while true
        wait(timer)
        gong = nauticalbells(now())
        println("Nautical bell gong strikes ", gong)
    end
end

nauticalbelltask()
