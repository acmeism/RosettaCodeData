Python 3.2.2 (default, Sep  4 2011, 09:51:08) [MSC v.1500 32 bit (Intel)] on win32
Type "copyright", "credits" or "license()" for more information.
>>> def f(x): return abs(x) ** 0.5 + 5 * x**3

>>> print(', '.join('%s:%s' % (x, v if v<=400 else "TOO LARGE!")
	           for x,v in ((y, f(float(y))) for y in input('\nnumbers: ').strip().split()[:11][::-1])))

11 numbers: 1 2 3 4 5 6 7 8 9 10 11
11:TOO LARGE!, 10:TOO LARGE!, 9:TOO LARGE!, 8:TOO LARGE!, 7:TOO LARGE!, 6:TOO LARGE!, 5:TOO LARGE!, 4:322.0, 3:136.73205080756887, 2:41.41421356237309, 1:6.0
>>>
