| asciiLower |
asciiLower := String new.
97 to: 122 do: [:asciiCode |
    asciiLower := asciiLower , asciiCode asCharacter
].
^asciiLower
