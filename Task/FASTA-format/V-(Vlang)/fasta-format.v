const data = (
">Rosetta_Example_1
THERECANBENOSPACE
>Rosetta_Example_2
THERECANBESEVERAL
LINESBUTTHEYALLMUST
BECONCATENATED"
)

fn main() {
	mut i := 0
	for i <= data.len {
		if data.substr_ni(i, i + 17) == ">Rosetta_Example_" {
			print("\n" + data.substr_ni(i, i + 18) + ": ")
			i = i + 17
		}
		else {
			if data.substr_ni(i, i + 1) > "\x20" {print(data[i].ascii_str())}
		}
		i++
	}
}
