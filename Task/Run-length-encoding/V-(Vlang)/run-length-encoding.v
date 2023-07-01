const test = "WWWWWWWWWWWWBWWWWWWWWWWWWBBBWWWWWWWWWWWWWWWWWWWWWWWWBWWWWWWWWWWWWWW"

fn main() {
	encoded := encode(test)
	println(encoded)
	println(decode(encoded))
}

fn encode(data string) string {
	mut encode :=""
	mut temp := []u8{}
	for key, value in data {
		if key > 1 && value != data[key - 1] {
			encode += temp.len.str() + temp[0].ascii_str()
			temp.clear()
		}
		temp << value
	}
	encode += temp.len.str() + temp[0].ascii_str()
	temp.clear()
	return encode
}

fn decode(data string) string {
	mut decode :=""
	mut temp := []u8{}
	for value in data {
		if value.is_digit() == false {
			decode += value.repeat(temp.bytestr().int())
			temp.clear()
		}
		else {temp << value}
	}
	return decode
}
