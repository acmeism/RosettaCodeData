struct Size {
	mut:
	width  int
	height int
}

fn (s &Size) area() int {
	return s.width * s.height
}

struct Colors {
	mut:
	color string
}

struct Button {
	Size
	Colors
	title string
}

fn main() {
	mut button_1 := Button{
		title:  "On"
		width: 4
		height: 2
	}
	button_1.color = "red"
	println(button_1)

	mut button_2 := Button{
		title:  "Off"
		height: 4
		color: "blue"
	}
	button_2.width = 8
	println("The area of button 2 is ${button_2.area()}")
}
