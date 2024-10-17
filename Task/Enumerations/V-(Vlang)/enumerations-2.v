mut color := Color.red
// V knows that `color` is a `Color`.
color = .green
println(color) // "green"
match color {
	.red {println("the color was red")}
	.green {println("the color was green")}
	.blue {println("the color was blue")}
}
