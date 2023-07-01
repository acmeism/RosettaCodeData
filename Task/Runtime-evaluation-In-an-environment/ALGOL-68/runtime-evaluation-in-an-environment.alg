PROC eval_with_x = (STRING code, INT a, b)STRING:
	(INT x=a; evaluate(code) ) + (INT x=b; evaluate(code));
print((eval_with_x("2 ** x", 3, 5), new line))
