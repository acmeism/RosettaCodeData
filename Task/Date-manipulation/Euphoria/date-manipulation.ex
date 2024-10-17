--Date Manipulation task from Rosetta Code wiki
--User:Lnettnay

include std/datetime.e

datetime dt

dt = new(2009, 3, 7, 19, 30)
dt = add(dt, 12, HOURS)
printf(1, "%s EST\n", {format(dt, "%B %d %Y %I:%M %p")})
