using Dates

function main()
    dtstr = "March 7 2009 7:30pm" # Base.Dates doesn't handle "EST"
    cleandtstr = replace(dtstr, r"(am|pm)"i, "")
    dtformat = dateformat"U dd yyyy HH:MM"
    dtime = parse(DateTime, cleandtstr, dtformat) +
        Hour(12 * contains(dtstr, r"pm"i)) # add 12h for the pm
    println(Dates.format(dtime + Hour(12), dtformat))
end

main()
