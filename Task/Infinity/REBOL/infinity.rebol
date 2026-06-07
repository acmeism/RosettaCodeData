Rebol [
    title: "Rosetta code: Infinity"
    file:  %Infinity.r3
    url:   https://rosettacode.org/wiki/Infinity
]

infinity?: func [
    "Test if infinity is supported and return positive infinity if so"
][
    attempt [1.0 / 0.0]
]

print either result: infinity? [
    ["Infinity supported! Value:" as-green result]
][   "Infinity is NOT supported on this platform"]
