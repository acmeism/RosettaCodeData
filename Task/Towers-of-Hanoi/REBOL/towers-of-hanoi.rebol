REBOL [
	Title: "Towers of Hanoi"
	Author: oofoe
	Date: 2009-12-08
	URL: http://rosettacode.org/wiki/Towers_of_Hanoi
]

hanoi: func [
	{Begin moving the golden disks from one pole to the next.
	 Note: when last disk moved, the world will end.}
	disks [integer!] "Number of discs on starting pole."
	/poles "Name poles."
	from to via
][
    if disks = 0 [return]
	if not poles [from: 'left  to: 'middle  via: 'right]

    hanoi/poles disks - 1 from via to
	print [from "->" to]
    hanoi/poles disks - 1 via to from
]

hanoi 4
