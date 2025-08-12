@[heap]
struct Foo {
}

fn (f Foo) test() int {
	return 123
}

fn (f Foo) test2() string {
	return "foo"
}

fn main() {
	foo := Foo{}
		
	$if ios || android {println("Running on a mobile device!")}
	$if linux && x64 {println("64-bit Linux.")}
	os := $if windows {"Windows"} $else {"Something Else"}
	println("Using ${os}")

	$for m in Foo.methods {
		$if m.return_type is int {
			print("${m.name} returns int: ")
			println(foo.$method())
		} $else $if m.return_type is string {
			print("${m.name} returns string: ")
			println(foo.$method())
		}
	}
}
