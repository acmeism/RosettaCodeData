result := ""
result .= TrianglesIntersect([[0,0],[5,0],[0,5]],	[[0,0],[5,0],[0,6]])	"`n"
result .= TrianglesIntersect([[0,0],[0,5],[5,0]],	[[0,0],[0,5],[5,0]])	"`n"
result .= TrianglesIntersect([[0,0],[5,0],[0,5]],	[[-10,0],[-5,0],[-1,6]])"`n"
result .= TrianglesIntersect([[0,0],[5,0],[2.5,5]],	[[0,4],[2.5,-1],[5,4]])	"`n"
result .= TrianglesIntersect([[0,0],[1,1],[0,2]],	[[2,1],[3,0],[3,2]])	"`n"
result .= TrianglesIntersect([[0,0],[1,1],[0,2]],	[[2,1],[3,-2],[3,4]])	"`n"
result .= TrianglesIntersect([[0,0],[1,0],[0,1]],	[[1,0],[2,0],[1,1]])	"`n"
MsgBox % result
return
