from __future__ import print_function
from shapely.geometry import LineString

if __name__=="__main__":
	line = LineString([(0,0),(1,0.1),(2,-0.1),(3,5),(4,6),(5,7),(6,8.1),(7,9),(8,9),(9,9)])
	print (line.simplify(1.0, preserve_topology=False))
