Red [
	title: "Write float arrays to file"
	author: "hinjolicious"
]

x: [1 2 3 1e11]
y: [1 1.4142135623730951 1.7320508075688772 316227.76601683791]

out: collect [repeat i length? x [keep/only reduce [x/:i y/:i]]]
write/lines %filename.txt out
print read %filename.txt

