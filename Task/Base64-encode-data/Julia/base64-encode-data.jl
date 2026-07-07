using Base64

file = read(download("https://rosettacode.org/favicon.ico"))
encoded = base64encode(file)
print(encoded)
