import rand

const (
	lo_abc = 'abcdefghijklmnopqrstuvwxyz'
	up_abc = 'ABCDEFGHIJKLMNIPQRSTUVWXYZ'
)

fn main() {
	key := rand.int_in_range(2, 25) or {13}
	encrypted := caesar_encrypt('The five boxing wizards jump quickly', key)
	println(encrypted)
	println(caesar_decrypt(encrypted, key))
}

fn caesar_encrypt(str string, key int) string {
	offset := key % 26
	if offset == 0 {return str}
	mut nchr := u8(0)
	mut chr_arr := []u8{}
	for chr in str {
		if chr.ascii_str() in up_abc.split('') {
			nchr = chr + u8(offset)
			if nchr > u8(90) {nchr -= 26}
		}
		else if chr.ascii_str() in lo_abc.split('') {
			nchr = chr + u8(offset)
			if nchr > u8(122) {nchr -= 26}
		}
		else {nchr = chr}
		chr_arr << nchr
	}
	return chr_arr.bytestr()
}

fn caesar_decrypt(str string, key int) string {
	return caesar_encrypt(str, 26 - key)
}
