? def q1 := makeQuaternion(2,3,4,5)
# value: (2 + 3i + 4j + 5k)

? def q2 := makeQuaternion(3,4,5,6)
# value: (3 + 4i + 5j + 6k)

? q1+q2
# value: (5 + 7i + 9j + 11k)

? q1*q2
# value: (-56 + 16i + 24j + 26k)

? q2*q1
# value: (-56 + 18i + 20j + 28k)

? q1+(-2)
# value: (0 + 3i + 4j + 5k)
