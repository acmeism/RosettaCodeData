Python 3.4.1 (v3.4.1:c0e311e010fc, May 18 2014, 10:38:22) [MSC v.1600 32 bit (Intel)] on win32
Type "copyright", "credits" or "license()" for more information.
>>> for calc in '''   -(-2147483647-1)
   2000000000 + 2000000000
   -2147483647 - 2147483647
   46341 * 46341
   (-2147483647-1) / -1'''.split('\n'):
	ans = eval(calc)
	print('Expression: %r evaluates to %s of type %s'
	      % (calc.strip(), ans, type(ans)))

	
Expression: '-(-2147483647-1)' evaluates to 2147483648 of type <class 'int'>
Expression: '2000000000 + 2000000000' evaluates to 4000000000 of type <class 'int'>
Expression: '-2147483647 - 2147483647' evaluates to -4294967294 of type <class 'int'>
Expression: '46341 * 46341' evaluates to 2147488281 of type <class 'int'>
Expression: '(-2147483647-1) / -1' evaluates to 2147483648.0 of type <class 'float'>
>>>
