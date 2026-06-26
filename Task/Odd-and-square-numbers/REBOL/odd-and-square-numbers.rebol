Rebol [
    title: "Rosetta code: Odd and square numbers"
    file:  %Odd_and_square_numbers.r3
    url:   https://rosettacode.org/wiki/Odd_and_square_numbers
]

odd-and-square: function[low [number!] limit [number!]][
    if even? n: to integer! square-root low [n: n + 1]
    limit: square-root limit
    collect [
        while [n < limit][
            keep n * n
            n: n + 2
        ]
    ]
]
print "Odd square numbers in range 100 to 1000:"
probe odd-and-square 100 1000
