import encoding.hex
fn decode(s string) ?[]u8 {
    return hex.decode(s)
}

fn main() {
    println("${'Char':-7} ${'Unicode':7}\tUTF-8 encoded\tDecoded")
    for codepoint in [`A`, `ö`, `Ж`, `€`, `𝄞`] {
        encoded := codepoint.bytes().hex()
        decoded := decode(encoded)?
        println("${codepoint:-7} U+${codepoint:04X}\t${encoded:-12}\t${decoded.bytestr()}")
    }
}
