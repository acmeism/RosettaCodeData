>>> def eval_with_x(code, a, b):
	return eval(code, {'x':b}) - eval(code, {'x':a})

>>> eval_with_x('2 ** x', 3, 5)
24
