Red [
	title: "Shell Sort"
	author: "hinjolicious"
	resources: "Red Sensei, Rosetta Code, etc."
]

shell-sort: function [
    "Sorts a block in place using Shell sort algorithm"
    a [block!]
][
	n: length? a
	g: n >> 1
    while [g > 0][
        i: g + 1
        while [i <= n][
            e: a/(i)
            j: i
            while [all [j > g  e < a/(j - g)]][
                a/(j): a/(j - g)
                j: j - g
            ]
            a/(j): e
            i: i + 1
        ]
		g: g >> 1
    ]
    a
]

random/seed 1
max: 10000
dat: collect [loop max [keep random max]]

t: now/time/precise
shell-sort dat
print ["shell-sort: " now/time/precise - t]
print ["sorted: " dat]
