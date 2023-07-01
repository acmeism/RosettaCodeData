sec = 6000005
week = floor(sec/60/60/24/7)
if week > 0 see sec
   see " seconds is " + week + " weeks " ok
day = floor(sec/60/60/24) % 7
if day > 0 see day
   see " days " ok
hour = floor(sec/60/60) % 24
if hour > 0 see hour
   see " hours " ok
minute = floor(sec/60) % 60
if minute > 0 see minute
   see " minutes " ok
second = sec % 60
if second > 0 see second
   see " seconds" + nl ok
