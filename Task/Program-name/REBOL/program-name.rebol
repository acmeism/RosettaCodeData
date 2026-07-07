Rebol [
    title: "Rosetta code: Program name"
    file:  %Program_name.r3
    url:   https://rosettacode.org/wiki/Program_name
]

if path: system/options/script [
    print ["Script path:" as-green path]
    print ""
    foreach [k v] first load/header path [
        if :v [ printf [10 ": "][k v] ]
    ]
]
