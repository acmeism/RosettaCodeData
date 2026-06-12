v1 := [5,-6,4]
v2 := [8,5,-30]
a := getAngle(v1, v2)
cp := crossProduct(v1, v2)
ncp := normalize(cp)
np := aRotate(v1, ncp, a)
for i, v in np
    result .= v ", "
MsgBox % result := "[" Trim(result, ", ") "]"
return

norm(v) {
    return Sqrt(v[1]*v[1] + v[2]*v[2] + v[3]*v[3])
}
normalize(v) {
    length := norm(v)
    return [v[1]/length, v[2]/length, v[3]/length]
}
dotProduct(v1, v2) {
    return v1[1]*v2[1] + v1[2]*v2[2] + v1[3]*v2[3]
}
crossProduct(v1, v2) {
    return [v1[2]*v2[3] - v1[3]*v2[2], v1[3]*v2[1] - v1[1]*v2[3], v1[1]*v2[2] - v1[2]*v2[1]]
}
getAngle(v1, v2) {
    return ACos(dotProduct(v1, v2) / (norm(v1)*norm(v2)))
}
matrixMultiply(matrix, v) {
    return [dotProduct(matrix[1], v), dotProduct(matrix[2], v), dotProduct(matrix[3], v)]
}
aRotate(p, v, a) {
    ca:=Cos(a), sa:=Sin(a), t:=1-ca, x:=v[1], y:=v[2], z:=v[3]
    r := [[ca + x*x*t, x*y*t - z*sa, x*z*t + y*sa]
    ,    [x*y*t + z*sa, ca + y*y*t, y*z*t - x*sa]
    ,    [z*x*t - y*sa, z*y*t + x*sa, ca + z*z*t]]
    return matrixMultiply(r, p)
}
