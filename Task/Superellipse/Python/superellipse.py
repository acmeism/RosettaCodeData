# Superellipse drawing in Python 2.7.9
# pic can see at http://www.imgup.cz/image/712

import matplotlib.pyplot as plt
from math import sin, cos, pi

def sgn(x):
	return ((x>0)-(x<0))*1

a,b,n=200,200,2.5 # param n making shape
na=2/n
step=100 # accuracy
piece=(pi*2)/step
xp=[];yp=[]

t=0
for t1 in range(step+1):
	# because sin^n(x) is mathematically the same as (sin(x))^n...
	x=(abs((cos(t)))**na)*a*sgn(cos(t))
	y=(abs((sin(t)))**na)*b*sgn(sin(t))
	xp.append(x);yp.append(y)
	t+=piece

plt.plot(xp,yp) # plotting all point from array xp, yp
plt.title("Superellipse with parameter "+str(n))
plt.show()
