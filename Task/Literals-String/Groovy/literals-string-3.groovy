def gString2 = "1 + 1 = ${1 + 1}"
assert gString2 == '1 + 1 = 2'

def gString3 = "1 + 1 = \${1 + 1}"
assert gString3 == '1 + 1 = ${1 + 1}'
