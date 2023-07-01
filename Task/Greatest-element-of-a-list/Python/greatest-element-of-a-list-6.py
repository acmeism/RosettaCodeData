'''Non-numeric maxima'''

print(
    f'max a-z: "{max(["epsilon", "zeta", "eta", "theta"])}"'
)
print(
    f'max length: "{max(["epsilon", "zeta", "eta", "theta"], key=len)}"'
)
print(
    'max property k by a-z: ' + str(max([
        {"k": "epsilon", "v": 2},
        {"k": "zeta", "v": 4},
        {"k": "eta", "v": 32},
        {"k": "theta", "v": 16}], key=lambda x: x["k"]))
)
print(
    'max property k by length: ' + str(max([
        {"k": "epsilon", "v": 2},
        {"k": "zeta", "v": 4},
        {"k": "eta", "v": 32},
        {"k": "theta", "v": 16}], key=lambda x: len(x["k"])))
)
print(
    'max property v: ' + str(max([
        {"k": "epsilon", "v": 2},
        {"k": "zeta", "v": 4},
        {"k": "eta", "v": 32},
        {"k": "theta", "v": 16}], key=lambda x: x["v"]))
)
