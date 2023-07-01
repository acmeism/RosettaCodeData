from __future__ import print_function
from shapely.geometry import Polygon

def PolyOverlaps(poly1, poly2):
	poly1s = Polygon(poly1)
	poly2s = Polygon(poly2)
	return poly1s.intersects(poly2s)

if __name__=="__main__":
	t1 = [[0,0],[5,0],[0,5]]
	t2 = [[0,0],[5,0],[0,6]]
	print (PolyOverlaps(t1, t2), True)

	t1 = [[0,0],[0,5],[5,0]]
	t2 = [[0,0],[0,6],[5,0]]
	print (PolyOverlaps(t1, t2), True)

	t1 = [[0,0],[5,0],[0,5]]
	t2 = [[-10,0],[-5,0],[-1,6]]
	print (PolyOverlaps(t1, t2), False)

	t1 = [[0,0],[5,0],[2.5,5]]
	t2 = [[0,4],[2.5,-1],[5,4]]
	print (PolyOverlaps(t1, t2), True)

	t1 = [[0,0],[1,1],[0,2]]
	t2 = [[2,1],[3,0],[3,2]]
	print (PolyOverlaps(t1, t2), False)

	t1 = [[0,0],[1,1],[0,2]]
	t2 = [[2,1],[3,-2],[3,4]]
	print (PolyOverlaps(t1, t2), False)

	#Barely touching
	t1 = [[0,0],[1,0],[0,1]]
	t2 = [[1,0],[2,0],[1,1]]
	print (PolyOverlaps(t1, t2), "?")
