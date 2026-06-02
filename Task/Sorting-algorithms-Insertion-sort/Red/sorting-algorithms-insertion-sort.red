Red [
	title: "Insertion Sort"
	author: "hinjolicious"
	resources: "Red's Bubble Sort example"
]

insertion: function [a][
	n: length? a
	i: 2
	while [i <= n] [
        v: a/(i)
		j: i - 1
		while [all [j >= 1  a/(j) > v]] [
			a/(j + 1): a/(j)
			j: j - 1
		]
		a/(j + 1): v
		i: i + 1
	]
	a
]

random/seed 1
max: 10000
dat: collect [loop max [keep random max]]

t: now/time/precise
insertion dat
print ["insertion: " now/time/precise - t]
print ["sorted: " dat]
