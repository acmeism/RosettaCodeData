fn vlq_encode_4bytes(n u32) []u8 {
	mut bytes := []u8{len: 4}
	bytes[0] = u8((n & 0x7f) | 0x80)
	bytes[1] = u8(((n >> 7) & 0x7f) | 0x80)
	bytes[2] = u8(((n >> 14) & 0x7f) | 0x80)
	bytes[3] = u8((n >> 21) & 0x7f) // cleared on last byte
	return bytes
}

fn vlq_decode_4bytes(bytes []u8) u32 {
	mut n := u32(0)
	n |= u32(bytes[0] & 0x7f) << 0
	n |= u32(bytes[1] & 0x7f) << 7
	n |= u32(bytes[2] & 0x7f) << 14
	n |= u32(bytes[3] & 0x7f) << 21
	return n
}

fn byte_to_hex(b u8) string {
	hex := b.hex()
	return if hex.len == 1 { '0' + hex } else { hex }
}

fn main() {
	values := [u32(0x200000), u32(0x1fffff)]
	for x in values {
		encoded := vlq_encode_4bytes(x)
		hex_str := encoded.map(byte_to_hex).join('')
		println('$x encodes into ${encoded.len} bytes: $hex_str')
		decoded := vlq_decode_4bytes(encoded)
		println('$decoded decoded')
	}
}
