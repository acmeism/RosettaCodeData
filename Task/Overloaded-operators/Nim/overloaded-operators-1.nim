type Vector = tuple[x, y, z: float]

func `+`(a, b: Vector): Vector = (a.x + b.x, a.y + b.y, a.z + b.z)

echo (1.0, 2.0, 3.0) + (4.0, 5.0, 6.0)  # print (x: 5.0, y: 7.0, z: 9.0)
