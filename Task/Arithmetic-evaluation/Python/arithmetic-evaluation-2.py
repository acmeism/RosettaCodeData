>>> import ast
>>>
>>> expr="2 * (3 -1) + 2 * 5"
>>> node = ast.parse(expr, mode='eval')
>>> print(ast.dump(node).replace(',', ',\n'))
Expression(body=BinOp(left=BinOp(left=Num(n=2),
 op=Mult(),
 right=BinOp(left=Num(n=3),
 op=Sub(),
 right=Num(n=1))),
 op=Add(),
 right=BinOp(left=Num(n=2),
 op=Mult(),
 right=Num(n=5))))
>>> code_object = compile(node, filename='<string>', mode='eval')
>>> eval(code_object)
14
>>> # lets modify the AST by changing the 5 to a 6
>>> node.body.right.right.n
5
>>> node.body.right.right.n = 6
>>> code_object = compile(node, filename='<string>', mode='eval')
>>> eval(code_object)
16
