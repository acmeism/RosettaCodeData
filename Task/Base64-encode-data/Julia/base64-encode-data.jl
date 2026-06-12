using Requests

file = read(get("https://rosettacode.org/favicon.ico"))
encoded = base64encode(file)

print(encoded)
