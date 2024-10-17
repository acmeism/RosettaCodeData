// Embedded structs

struct Size {
	mut:
	width  int
	height int = 2
}

fn (s &Size) area() int {
	return s.width * s.height
}

// The 'Size' struct is embedded into the 'Button' struct

struct Button {
	Size
	title string = "Click me"
}

// With embedding, the struct 'Button' will get all the fields and methods from struct 'Size'

mut button := Button{}
button.width = 3

println("${button.Size.area()}")  // 'Size' struct methods can be used by the 'Button' struct
println("${button.area()}")  // You can use the method names directly
