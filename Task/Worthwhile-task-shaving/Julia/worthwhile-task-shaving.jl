shaved  = [1, 5, 30, 60, 300, 1800, 3600, 21600, 86400]
columns = [" 1 Second", " 5 Seconds", "30 Seconds", " 1 Minute", " 5 Minutes", "30 Minutes", " 1 Hour", " 6 Hours", " 1 Day"]
diy, minute, hour, day, week = 365.25, 60, 60 * 60, 60 * 60 * 24, 60 * 60 * 24 * 7
month, year = day * diy / 12, day * diy
freq = [50 * diy, 5 * diy, diy, diy / 7, 12, 1]

fmt(t, interval) = rpad(lpad(Int(round(t)), 3) * " $interval" * (t > 1 ? "s" : ""), 15)

println(' '^34, "How Often You Do the Task\n")
foreach(s -> print(rpad(s, 15)), ["Shaved-off  |", " 50/Day", " 5/Day", " Daily", " Weekly", " Monthly", " Yearly"])
println("\n", '-'^100)

for y in 1:9
   row = lpad(columns[y] * " | ", 14)
   for x in 1:6
      t = freq[x] * shaved[y] * 5
      row *= t < minute ? fmt(t, "Second") : t < hour ? fmt(t / minute, "Minute") : t < day ? fmt(t / hour,   "Hour") :
         t < day * 14 ? fmt(t / day, "Day") : t < week * 9 ? fmt(t / week, "Week") : t < year ? fmt(t / month, "Month") : "   n/a         "
   end
   println(row)
end
