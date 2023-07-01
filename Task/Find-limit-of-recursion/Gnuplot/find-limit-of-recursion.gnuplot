# Put this in a file foo.gnuplot and run as
#     gnuplot foo.gnuplot

# probe by 1 up to 1000, then by 1% increases
if (! exists("try")) { try=0 }
try=(try<1000 ? try+1 : try*1.01)

recurse(n) = (n > 0 ? recurse(n-1) : 'ok')
print "try recurse ", try
print recurse(try)
reread
