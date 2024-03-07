import re

# Input texts
texts = [
    "The quick brown fox jumped over the lazy dog.",
    """I was looking at some rhododendrons in my back garden,
dressed in my khaki shorts, when the telephone rang.

As I answered it, I cheerfully glimpsed that the July sun
caused a fragment of black pine wax to ooze on the velvet quilt
laying in my patio.""",
    "sphinx of black quartz, judge my vow."
]

# Mapping of replacements
replacements = [
    ("ch", "χ"), ("th", "θ"), ("ps", "ψ"), ("ph", "f"), (r"s(\W)", r"ς\1"), ("Ch", "Χ"),
    ("Th", "Θ"), ("Ps", "Ψ"), ("Ph", "F"), ("ee", "h"), ("ck", "κ"), ("rh", "r"), ("kh", "χ"),
    ("Kh", "Χ"), ("oo", "w"), ("a", "α"), ("b", "β"), ("c", "κ"), ("d", "δ"), ("e", "ε"),
    ("f", "φ"), ("g", "γ"), ("h", "η"), ("i", "ι"), ("j", "ι"), ("k", "κ"), ("l", "λ"),
    ("m", "μ"), ("n", "ν"), ("o", "ο"), ("p", "π"), ("q", "κ"), ("r", "ρ"), ("s", "σ"),
    ("t", "τ"), ("u", "υ"), ("v", "β"), ("w", "ω"), ("x", "ξ"), ("y", "υ"), ("z", "ζ"),
    ("D", "Δ"), ("F", "Φ"), ("G", "Γ"), ("J", "I"), ("L", "Λ"), ("P", "Π"), ("Q", "Κ"),
    ("R", "Ρ"), ("S", "Σ"), ("Y", "U"), ("W", "Ω"), ("X", "Ξ")
]

# Function to apply replacements
def replace_text(text, replacements):
    for old, new in replacements:
        if re.search(r"\W", old):  # If the key contains special characters, treat it as a regex
            text = re.sub(old, new, text)
        else:
            text = text.replace(old, new)
    return text

# Apply replacements and print the results
for txt in texts:
    print(f"{txt}\n=>")
    txt = replace_text(txt, replacements)
    print(f"{txt}\n" + "="*65)
