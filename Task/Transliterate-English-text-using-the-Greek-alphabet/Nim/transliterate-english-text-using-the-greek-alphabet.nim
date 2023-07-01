import std/[strutils, unicode]

const Text = """I was looking at some rhododendrons in my back garden,
dressed in my khaki shorts, when the telephone rang.

As I answered it, I cheerfully glimpsed that the July sun
caused a fragment of black pine wax to ooze on the velvet quilt
laying in my patio."""

# Replacement table.
# It includes greek characters which look like ASCII ones but are actually different
# and coded using specific Unicode code points (as Α, Β, Ε, etc.).
const Replacements = {"CH": "Χ", "Ch": "Χ", "ch": "χ", "CK": "Κ", "Ck": "Κ", "ck": "κ",
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

# All replacements are done using a single call to "multiReplace".
var text = Text.multiReplace(Replacements)

# Replacing "σ" with "ς" is a bit more complicated, as we have to deal with Unicode strings.
const Sigma1 = "σ".toRunes[0]
const Sigma2 = "ς".toRunes[0]
var runes = text.toRunes
for i in 0..runes.high:
  let rune = runes[i]
  if rune == Sigma1:
    if i == runes.high or not runes[i + 1].isAlpha:
      runes[i] = Sigma2
echo runes
