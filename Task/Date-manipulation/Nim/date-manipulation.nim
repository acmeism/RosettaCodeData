import times

const Date = "March 7 2009 7:30pm EST"
echo "Original date is:        ", Date

var dt = Date.replace("EST", "-05:00").parse("MMMM d yyyy h:mmtt zzz")
echo "Original date in UTC is: ", dt.utc().format("MMMM d yyyy h:mmtt zzz")

dt = dt + initDuration(hours = 12)
echo "Date 12 hours later is:  ", dt.utc().format("MMMM d yyyy h:mmtt zzz")
