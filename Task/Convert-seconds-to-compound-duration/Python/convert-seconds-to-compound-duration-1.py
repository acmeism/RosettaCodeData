>>> def duration(seconds):
	t= []
	for dm in (60, 60, 24, 7):
		seconds, m = divmod(seconds, dm)
		t.append(m)
	t.append(seconds)
	return ', '.join('%d %s' % (num, unit)
			 for num, unit in zip(t[::-1], 'wk d hr min sec'.split())
			 if num)

>>> for seconds in [7259, 86400, 6000000]:
	print("%7d sec = %s" % (seconds, duration(seconds)))

	
   7259 sec = 2 hr, 59 sec
  86400 sec = 1 d
6000000 sec = 9 wk, 6 d, 10 hr, 40 min
>>>
