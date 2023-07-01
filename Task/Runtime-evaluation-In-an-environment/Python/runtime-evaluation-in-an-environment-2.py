>>> def eval_with_args(code, **kwordargs):
	return eval(code, kwordargs)

>>> code = '2 ** x'
>>> eval_with_args(code, x=5) - eval_with_args(code, x=3)
24
>>> code = '3 * x + y'
>>> eval_with_args(code, x=5, y=2) - eval_with_args(code, x=3, y=1)
7
