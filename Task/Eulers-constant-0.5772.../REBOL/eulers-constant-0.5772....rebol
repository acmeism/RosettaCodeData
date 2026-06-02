Rebol [
    title: "Rosetta code: Euler's constant 0.5772..."
    file:  %Euler's_constant.r3
    url:   https://rosettacode.org/wiki/Euler%27s_constant_0.5772...
]

euler-constant: func [
    "Compute Euler's constant γ ≈ 0.5772... using the classic definition"
    iterations [integer!]
    /local sum
][
    sum: 0.0
    repeat i iterations [sum: sum + (1.0 / i)]
    sum - log-e iterations
]

e: euler-constant 1000000 ;== 0.577216164900715
assert [e = 0.577216164900715]
