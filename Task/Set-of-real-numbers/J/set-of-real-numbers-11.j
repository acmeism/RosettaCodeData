intervalSet=: interval@('[',[,',',],')'"_)&":
A=: union/_2 intervalSet/\ zA
B=: union/_2 intervalSet/\ zB
diff=: A without B
