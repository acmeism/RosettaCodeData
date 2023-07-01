Python 2.7.5 (default, May 15 2013, 22:43:36) [MSC v.1500 32 bit (Intel)] on win32
Type "copyright", "credits" or "license()" for more information.
>>> for calc in '''   -(-2147483647-1)
   2000000000 + 2000000000
   -2147483647 - 2147483647
   46341 * 46341
   (-2147483647-1) / -1'''.split('\n'):
	ans = eval(calc)
	print('Expression: %r evaluates to %s of type %s'
	      % (calc.strip(), ans, type(ans)))

	
Expression: '-(-2147483647-1)' evaluates to 2147483648 of type <type 'long'>
Expression: '2000000000 + 2000000000' evaluates to 4000000000 of type <type 'long'>
Expression: '-2147483647 - 2147483647' evaluates to -4294967294 of type <type 'long'>
Expression: '46341 * 46341' evaluates to 2147488281 of type <type 'long'>
Expression: '(-2147483647-1) / -1' evaluates to 2147483648 of type <type 'long'>
>>>
