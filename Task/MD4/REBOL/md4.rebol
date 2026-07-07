Rebol [
    title: "Rosetta code: MD4"
    file:  %MD4.r3
    url:   https://rosettacode.org/wiki/MD4
]

string: "Rosetta Code"
print [
    mold string "has MD4 checksum:" as-green checksum string 'MD4
]

print [
    "^/Available checksums:" mold system/catalog/checksums
]
