if (!exists("bottles")) bottles = 99
print sprintf("%i bottles of beer on the wall", bottles)
print sprintf("%i bottles of beer", bottles)
print "Take one down, pass it around"
bottles = bottles - 1
print sprintf("%i bottles of beer on the wall", bottles)
print ""
if (bottles > 0) reread
