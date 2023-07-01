#Wherein I observe that Set Comprehension is not intrinsically dysfunctional. Nigel Galloway: October 28th., 2018
n = {n for x in range(0,101,20) for y in range(x,101,9) for n in range(y,101,6)}
g = {n for n in range(101)}
print(max(g.difference(n)))
