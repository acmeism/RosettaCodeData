Rebol [
    title: "Rosetta code: Vigenère cipher"
    file:  %Vigenere_cipher.r3
    url:   https://rosettacode.org/wiki/Vigenère_cipher
]

vigenere: context [
    letters: charset [#"A" - #"Z"]

    encrypt: function [
        "Encrypts a message using the Vigenère cipher"
        msg [string!] "plaintext string (mixed case, may contain non-alpha characters)"
        key [string!] "uppercase cipher key string (e.g. VIGENERECIPHER)"
    ][
        pos: 1
        result: copy ""
        foreach c msg [
            c: uppercase c
            ;; skip non-alphabetic characters (spaces, punctuation, etc.)
            if find letters c [
                append result #"A" + ((key/:pos - #"A" + c - #"A") % 26)
                pos: 1 + (pos % length? key)  ; advance key position, wrapping at key length
            ]
        ]
        result  ; return encrypted string
    ]

    decrypt: function [
        "Decrypts a Vigenère-encrypted message back to uppercase plaintext"
        msg [string!] "ciphertext string produced by encrypt (uppercase letters only)"
        key [string!] "same cipher key used during encryption"
    ] [
        pos: 1
        result: copy ""
        foreach c msg [
            c: uppercase c
            append result #"A" + ((26 + c - key/:pos) % 26)
            pos: 1 + (pos % length? key)  ; advance key position, wrapping at key length
        ]
        result  ; return decrypted string
    ]
]
text: "Beware the Jabberwock, my son! The jaws that bite, the claws that catch!"
key: "VIGENERECIPHER"

encr: vigenere/encrypt text key  ;; encrypt the plaintext
decr: vigenere/decrypt encr key  ;; decrypt it back — should match original letters (uppercased)

print text ;= original mixed-case text
print encr ;= encrypted ciphertext
print decr ;= decrypted result (uppercase, punctuation stripped during encryption)
