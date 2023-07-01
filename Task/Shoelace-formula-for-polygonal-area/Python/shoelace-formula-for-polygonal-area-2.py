# Even simpler:
# In python we can take an advantage of that x[-1] refers to the last element in an array, same as x[N-1].
# Introducing the index i=[0,1,2,...,N-1]; i-1=[-1,0,...,N-2]; N is the number of vertices of a polygon.
# Thus x[i] is a sequence of the x-coordinate of the polygon vertices, x[i-1] is the sequence shifted by 1 index.
# Note that the shift must be negative. The positive shift x[i+1] results in an error: x[N] index out of bound.

import numpy as np
# x,y are arrays containing coordinates of the polygon vertices
x=np.array([3,5,12,9,5])
y=np.array([4,11,8,5,6])
i=np.arange(len(x))
#Area=np.sum(x[i-1]*y[i]-x[i]*y[i-1])*0.5 # signed area, positive if the vertex sequence is counterclockwise
Area=np.abs(np.sum(x[i-1]*y[i]-x[i]*y[i-1])*0.5) # one line of code for the shoelace formula

# Remember that applying the Shoelace formula
# will result in a loss of precision if x,y have big offsets.
# Remove the offsets first, e.g.
# x=x-np.mean(x);y=y-np.mean(y)
# or
# x=x-x[0];y=y-y[0]
# before applying the Shoelace formula.
