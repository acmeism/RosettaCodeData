>>> def commonprefix(args, sep='/'):
	return os.path.commonprefix(args).rpartition(sep)[0]

>>> commonprefix(['/home/user1/tmp/coverage/test',
                  '/home/user1/tmp/covert/operator', '/home/user1/tmp/coven/members'])
'/home/user1/tmp'
