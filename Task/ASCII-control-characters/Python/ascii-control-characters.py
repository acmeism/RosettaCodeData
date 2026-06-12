import unicodedata

control_chars = [
    (i, chr(i))
    for i in range(128)
    if unicodedata.category(chr(i)) == 'Cc'
]

print(control_chars)
