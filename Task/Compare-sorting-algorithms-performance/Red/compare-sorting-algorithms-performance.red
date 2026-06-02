Red [
	title: "Compare Sorting Algorithms' Performance"
	author: "hinjolicious"
	resources: "Various: AI, Rosetta Code, Red Community Codes"
	needs: 'View
]

; bubble sort and insertion sort is not used (too slow!!!)
;#include %bubble-sort.red
;#include %insertion-sort.red
#include %quicksort.red
#include %radix-sort.red
#include %shell-sort.red

;#include %query-performance.red	; use hj-profiler-gab1.red instead (from Red's community codes)
;#include %write-float-arrays.red	; included
;#include %plotter.red				; will be run separately!
;#include %polynomial-fitting.red	; included in the plotter module

#include %hj-profiler-gab1.red

ones:	function [n][collect [loop n [keep 1]]]
sorted:	function [n][sort collect [loop n [keep random n]]]
rand:	function [n][collect [loop n [keep random n]]]

; build data for sorting...

; format would be like:
comment [///
[
 'ones [1 [1]
		2 [1 1]
		3 [1 1 1]
		4 [1 1 1 1]
		5 [1 1 1 1 1]]
 'sorted [1 [1]
		2 [1 1]
		3 [1 2 2]
		4 [3 3 4 4]
		5 [1 1 3 4 4]]
 'rand [1 [1]
		2 [2 1]
		3 [2 3 2]
		4 [3 1 3 2]
		5 [1 2 2 5 3]]
]
///]

print "Generate data..."
sort-data: collect [
	foreach seq ['ones 'sorted 'rand][
		print seq
		gen: get seq
		keep reduce [seq
			collect [
				n: 10000
				repeat i 10 [
					prin [n " "]
					keep reduce [n gen n]
					n: n + 10000
				]
				print ""
			]
		]
	]
]	

; output format would be like: (ready to be use by the plotter module!)
comment [///
[
	[[scatter "Data 1" blue cross 2 fit blue 1] [0 1 1 6 2 17 3 34 4 57 5 86 6 121 7 162 8 209 9 262 10 321]]
	[[scatter "Data 2" red plus 2 fit red 1] [0 18 1 10 2 28 3 56 4 93 5 105 6 147 7 188 8 252 9 274 10 338]]
]
///]

; collect timings of a sorting methods...

sorter: ['shell 'radix 'quick]
;recycle off

markers: [dot box cross plus triangle triangle-down triangle-left triangle-right]
colors: [red green blue purple orange]
mrkmod: 1 + length? markers
clrmod: 1 + length? colors

print "Sorting..."
vis-data: collect [

	mrkc: 1 ;start with 'dot
	foreach _sorter sorter [
		sort-f: get _sorter

		mrk: pick markers (mrkc // mrkmod) ;each sorting method has disctinc marker

		clrc: 1 ;start with 'red
		foreach [seq d] sort-data [
			sort-s: rejoin [to-string _sorter "-" to-string seq]
			print sort-s
			
			clr: pick colors (clrc // clrmod) ;each data sequence has distinc color
			
			_info: compose [scatter (sort-s) (clr) (mrk) 1 fit (clr) 1]
			keep/only reduce [_info
				collect [
					foreach [n l] d [
						prin [n " "]
						_d: copy l
						f: [sort-f _d]
						p: profile [f]
						t: to-float p/2/1
						print t
						keep reduce [n t]
					]
				]
			]
			clrc: clrc + 1
		]
		mrkc: mrkc + 1
	]
]

foreach v vis-data [print v]

write/lines %sort-timings.txt vis-data

print "Done."
print "Check output in file 'sort-timings.txt'"
print "Plug the data into the plotter app!"
