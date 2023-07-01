// Assigning methods to structs
struct HelloWorld {}

// Method's in Vlang are functions with special receiver arguments at the front (between fn and method name)
fn (sh HelloWorld) say_hello() {
	 println("Hello, world!")
}

fn (sb HelloWorld) say_bye() {
	 println("Goodbye, world!")
}

fn main() {

	//  instantiate object
	hw := HelloWorld{}
	
	// call methods of object
	hw.say_hello()
	hw.say_bye()
}
