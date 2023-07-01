from __future__ import print_function
from shapely.geometry import MultiPoint

if __name__=="__main__":
	pts = MultiPoint([(16,3), (12,17), (0,6), (-4,-6), (16,6), (16,-7), (16,-3), (17,-4), (5,19), (19,-8), (3,16), (12,13), (3,-4), (17,5), (-3,15), (-3,-9), (0,11), (-9,-3), (-4,-2), (12,10)])
	print (pts.convex_hull)
