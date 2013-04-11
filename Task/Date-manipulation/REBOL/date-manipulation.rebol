REBOL [
	Title: "Date Manipulation"
	Author: oofoe
	Date: 2009-12-06
	URL: http://rosettacode.org/wiki/Date_Manipulation
]

; Only North American zones here -- feel free to extend for your area.

zones: [
	NST -3:30 NDT -2:30 AST -4:00 ADT -3:00 EST -5:00 EDT -4:00
	CST -6:00 CDT -5:00 MST -7:00 MDT -6:00 PST -8:00 PDT -7:00 AKST -9:00
	AKDT -8:00 HAST -10:00 HADT -9:00]

read-time: func [
	text
	/local m d y t z
][
	parse load text [
		set m word! (m: index? find system/locale/months to-string m)
		set d integer!  set y integer!
		set t time!  set tz word!]
	to-date reduce [y m d t  zones/:tz]
]

print 12:00 + read-time "March 7 2009 7:30pm EST"
