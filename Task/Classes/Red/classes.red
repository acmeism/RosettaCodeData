bike: object [
	frame-material: "aluminium"
	wheel-size: 29
	color: "black"
	set-color: func [value][color: value]
]

e-bike: make bike [
	motor-type: "brushless"
]
print ["e-bike/frame-material : " e-bike/frame-material]
print ["e-bike/motor-type     : " e-bike/motor-type]


mountain-bike: make bike [
	fork-stroke: 150
]

green-mountain-bike: copy mountain-bike
green-mountain-bike/set-color "green"

print ["green-mountain-bike/wheel-size  : " green-mountain-bike/wheel-size]
print ["green-mountain-bike/fork-stroke : " green-mountain-bike/fork-stroke]
print ["green-mountain-bike/color       : " green-mountain-bike/color]

default-mountain-bike: copy mountain-bike

print ["default-mountain-bike/wheel-size  : " default-mountain-bike/wheel-size]
print ["default-mountain-bike/fork-stroke : " default-mountain-bike/fork-stroke]
print ["default-mountain-bike/color       : " default-mountain-bike/color]
