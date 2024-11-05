import maps
import encoding.utf8

const txt = "I was looking at some rhododendrons in my back garden,
dressed in my khaki shorts, when the telephone rang.

As I answered it, I cheerfully glimpsed that the July sun
caused a fragment of black pine wax to ooze on the velvet quilt
laying in my patio."

const rpl = {"CH": "Χ", "Ch": "Χ", "ch": "χ", "CK": "Κ", "Ck": "Κ", "ck": "κ",
			"EE": "Η", "Ee": "Η", "ee": "η", "KH": "Χ", "Kh": "Χ", "kh": "χ",
			"OO": "Ω", "Oo": "Ω", "oo": "ω", "PH": "Φ", "Ph": "Φ", "ph": "ϕ",
			"PS": "Ψ", "Ps": "Ψ", "ps": "ψ", "RH": "Ρ", "Rh": "Ρ", "rh": "ρ",
			"TH": "Θ", "Th": "Θ", "th": "θ", "A": "Α", "a": "α", "B": "Β",
			"b": "β", "C": "Κ", "c": "κ", "D": "Δ", "d": "δ", "E": "Ε", "e": "ε",
			"F": "Φ", "f": "ϕ", "G": "Γ", "g": "γ", "H": "Ε", "h": "ε", "I": "Ι",
			"i": "ι", "J": "Ι", "j": "ι", "K": "Κ", "k": "κ", "L": "Λ", "l": "λ",
			"M": "Μ", "m": "μ", "N": "Ν", "n": "ν", "O": "Ο", "o": "ο", "P": "Π",
			"p": "π", "Q": "Κ", "q": "κ", "R": "Ρ", "r": "ρ", "S": "Σ", "s": "σ",
			"T": "Τ", "t": "τ", "U": "Υ", "u": "υ", "V": "Β", "v": "β", "W": "Ω",
			"w": "ω", "X": "Ξ", "x": "ξ", "Y": "Υ", "y": "υ", "Z": "Ζ", "z": "ζ"}

fn main() {
	flat_arr := maps.flat_map[string, string, string](rpl, fn (key string, val string) []string {
			mut arr := [key]
			arr << val
			return arr})
	mut rune_arr := txt.replace_each(flat_arr).runes()
	for idx, chr in rune_arr {
		if chr == "σ".runes()[0] && !utf8.is_letter(rune_arr[idx + 1]) {rune_arr[idx] = "ς".runes()[0]}
	}
	println(rune_arr.string())
}
