>>> import random, math
>>> throws = 1000
>>> 4.0 * sum(math.hypot(*[random.random()*2-1
	                 for q in [0,1]]) < 1
              for p in xrange(throws)) / float(throws)
3.1520000000000001
>>> throws = 1000000
>>> 4.0 * sum(math.hypot(*[random.random()*2-1
	                 for q in [0,1]]) < 1
              for p in xrange(throws)) / float(throws)
3.1396359999999999
>>> throws = 100000000
>>> 4.0 * sum(math.hypot(*[random.random()*2-1
	                 for q in [0,1]]) < 1
              for p in xrange(throws)) / float(throws)
3.1415666400000002
