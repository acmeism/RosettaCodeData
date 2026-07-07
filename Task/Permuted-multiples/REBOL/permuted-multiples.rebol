Rebol [
    title: "Rosetta code: Permuted multiples"
    file:  %Permuted_multiples.r3
    url:   https://rosettacode.org/wiki/Permuted_multiples
]

n: 1
forever [
    s: sort form n
    if all [
        s = sort form n2: 2 * n
        s = sort form n3: 3 * n
        s = sort form n4: 4 * n
        s = sort form n5: 5 * n
        s = sort form n6: 6 * n
    ][
        print [n n2 n3 n4 n5 n6]
        break
    ]
    ++ n
]
