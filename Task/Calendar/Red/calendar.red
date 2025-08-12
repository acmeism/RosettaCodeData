Red [ "Print Calendar in six months across and for two rows - Hinjo, 20 July 2025" ]

months: system/locale/months

; get day from year, month, week, and weekday!
getday: function [y[integer!] m[integer!] w[integer!] wd[integer!]] [
	fd: to-date reduce [1 m y] ; first day!
	swd: fd/weekday + 1  if swd > 7 [swd: 1] ; shift from mon=1 to sun=1
	ofs: (w - 1) * 7 + (wd - swd) ; offset
	d: fd + ofs ; date
	either d/month = m [d/day][0] ; return day or zero!
]

; center string
centr: function [str wid] [
	gap: wid - length? str
	lpad: to-integer gap / 2
	pad/left str wid - lpad
	pad str wid
]

either "" = y: ask "Year (ENTER for current): " [y: now/year][y: to-integer y]

print centr "[ S N O O P Y ]" 130 ; print snoopy block centered
print centr to-string y 130 ; print year

foreach r [[1 2 3 4 5 6][7 8 9 10 11 12]] [
	; print month's name
	foreach m r [
		prin rejoin [centr months/:m 21 " "]
	] print ""
	
	; print for each week across months
	foreach w [0 1 2 3 4 5 6] [
		; each months
		foreach m r [
			either w = 0 [ ; print weekdays
				foreach d ["Su" "Mo" "Tu" "We" "Th" "Fr" "Sa"]
					[prin [form pad d 3]]
			] [	
				foreach wd [1 2 3 4 5 6 7] [ ; print dates
					; reconstruct the day
					either 0 < dt: getday y m w wd [
						prin [form pad/left dt 2]
					] [	
						prin "  "
					] prin " "
				]	
			] prin " "
		] print ""
	] print ""
]
