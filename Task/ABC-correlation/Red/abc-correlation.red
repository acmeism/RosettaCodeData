is-abc-word?: func [
	s [string!]
	/local
	letter
	nba
	nbb
	nbc
]
[
	nba: 0
	nbb: 0
	nbc: 0
	foreach letter s [
		if letter = #"a" [ nba: nba + 1]
		if letter = #"b" [ nbb: nbb + 1]
		if letter = #"c" [ nbc: nbc + 1]
	]
	return ( (nba = nbb ) and (nbb = nbc))
]

;- test
list: [
	"aluminium"
	"abc"
	"internet"
	"adb"
	"cda"
	"blank"
	"black"
	"venus"
	"earth"
	"mars"
	"jupiter"
	"saturn"
	"uranus"
	"neptune"
	"pluto"
]

foreach word list [
	if  is-abc-word? word  [ print word ]
]
