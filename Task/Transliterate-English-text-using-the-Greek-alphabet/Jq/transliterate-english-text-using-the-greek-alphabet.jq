def texts: [

  "The quick brown fox jumped over the lazy dog.",

  "I was looking at some rhododendrons in my back garden,\n" +
  "dressed in my khaki shorts, when the telephone rang.\n" +
  "\n" +
  "As I answered it, I cheerfully glimpsed that the July sun\n" +
  "caused a fragment of black pine wax to ooze on the velvet quilt\n" +
  "laying in my patio.",

  "sphinx of black quartz, judge my vow."
];

# "ς" is handled separately
def replacements:
 {
    "ch" : "χ", "th" : "θ", "ps" : "ψ", "ph" : "f", "Ch" : "Χ",
    "Th" : "Θ", "Ps" : "Ψ", "Ph" : "F", "ee" : "h", "ck" : "κ", "rh" : "r", "kh" : "χ",
    "Kh" : "Χ", "oo" : "w", "a" : "α", "b" : "β", "c" : "κ", "d" : "δ", "e" : "ε",
    "f" : "φ", "g" : "γ", "h" : "η", "i" : "ι", "j" : "ι", "k" : "κ", "l" : "λ",
    "m" : "μ", "n" : "ν", "o" : "ο", "p" : "π", "q" : "κ", "r" : "ρ", "s" : "σ",
    "t" : "τ", "u" : "υ", "v" : "β", "w" : "ω", "x" : "ξ", "y" : "υ", "z" : "ζ",
    "D" : "Δ", "F" : "Φ", "G" : "Γ", "J" : "I", "L" : "Λ", "P" : "Π", "Q" : "Κ",
    "R" : "Ρ", "S" : "Σ", "Y" : "U", "W" : "Ω", "X" : "Ξ" };

def translate($replacements):
  gsub("s(?<W>\\W)"; "ς\(.W)")
  | reduce ($replacements|keys_unsorted[]) as $key (.;
      gsub($key; $replacements[$key])) ;

replacements as $replacements
| texts[]
| ., "=>", translate($replacements), ""
