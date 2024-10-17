const (
	key = "VIGENERECIPHER"
	text = "Beware the Jabberwock, my son! The jaws that bite, the claws that catch!"
)

fn main() {
	encoded := vigenere(text, key, true)
	println(encoded)
	decoded := vigenere(encoded, key, false)
	println(decoded)
}

fn vigenere(str string, key string, encrypt bool) string {
	mut txt :=''
	mut chr_arr := []u8{}
	mut kidx, mut cidx := 0, 0
	if encrypt == true {txt = str.to_upper()}
	else {txt = str}
	for chr in txt {
		if (chr > 64 && chr < 91) == false {continue}
		if encrypt == true {cidx = (chr + key[kidx] - 130) % 26}
		else {cidx = (chr - key[kidx] +  26) % 26}
		chr_arr << u8(cidx + 65)
		kidx = (kidx + 1) % key.len
	}
	return chr_arr.bytestr()
}
