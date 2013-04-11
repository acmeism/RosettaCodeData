$ awk '{print "and:"($1&&$2),"or:"($1||$2),"not:"!$1}'
0 0
and:0 or:0 not:1
0 1
and:0 or:1 not:1
1 0
and:0 or:1 not:0
1 1
and:1 or:1 not:0
