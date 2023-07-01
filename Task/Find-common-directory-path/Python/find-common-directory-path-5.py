>>> from itertools import takewhile
>>> def allnamesequal(name):
	return all(n==name[0] for n in name[1:])

>>> def commonprefix(paths, sep='/'):
	bydirectorylevels = zip(*[p.split(sep) for p in paths])
	return sep.join(x[0] for x in takewhile(allnamesequal, bydirectorylevels))

>>> commonprefix(['/home/user1/tmp/coverage/test',
                  '/home/user1/tmp/covert/operator', '/home/user1/tmp/coven/members'])
'/home/user1/tmp'
>>> # And also
>>> commonprefix(['/home/user1/tmp', '/home/user1/tmp/coverage/test',
                  '/home/user1/tmp/covert/operator', '/home/user1/tmp/coven/members'])
'/home/user1/tmp'
>>>
