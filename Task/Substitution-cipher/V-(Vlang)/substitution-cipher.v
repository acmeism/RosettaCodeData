const (
	key = "]kYV}(!7P\$n5_0i R:?jOWtF/=-pe'AD&@r6%ZXs\"v*N[#wSl9zq2^+g;LoB`aGh{3.HIu4fbK)mU8|dMET><,Qc\\C1yxJ"
	text = "The quick brown fox jumps over the lazy dog, who barks VERY loudly!"
)

fn main() {
	encoded := encode(text)
	println(encoded)
	println(decode(encoded))
}

fn encode(str string) string {
	mut chr_arr := []u8{}
	for chr in str {
		chr_arr << key[u8(chr - 32)]
	}
	return chr_arr.bytestr()
}

fn decode(str string) string {
	mut chr_arr := []u8{}
	for chr in str {
		chr_arr << u8(key.index_u8(chr) + 32)
	}
	return chr_arr.bytestr()
}
