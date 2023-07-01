import "./vector" for Vector3

var v1 = Vector3.new(1, 3, -5)
var v2 = Vector3.new(4, -2, -1)

System.print("The dot product of %(v1) and %(v2) is %(v1.dot(v2)).")
