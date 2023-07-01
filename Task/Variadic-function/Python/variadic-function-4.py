>>> def printargs(*positionalargs, **keywordargs):
	print "POSITIONAL ARGS:\n  " + "\n  ".join(repr(x) for x in positionalargs)
	print "KEYWORD ARGS:\n  " + '\n  '.join(
		"%r = %r" % (k,v) for k,v in keywordargs.iteritems())

	
>>> printargs(1,'a',1+0j, fee='fi', fo='fum')
POSITIONAL ARGS:
  1
  'a'
  (1+0j)
KEYWORD ARGS:
  'fee' = 'fi'
  'fo' = 'fum'
>>> alist = [1,'a',1+0j]
>>> adict = {'fee':'fi', 'fo':'fum'}
>>> printargs(*alist, **adict)
POSITIONAL ARGS:
  1
  'a'
  (1+0j)
KEYWORD ARGS:
  'fee' = 'fi'
  'fo' = 'fum'
>>>
