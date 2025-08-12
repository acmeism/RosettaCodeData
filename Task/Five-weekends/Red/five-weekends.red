Red [ "Five Weekends - Hinjo, 20 July 2025" ]

; get day from year, month, week, and weekday!
getday: function [y[integer!] m[integer!] w[integer!] wd[integer!]] [
	fd: to-date reduce [1 m y] ; first day!
	swd: fd/weekday + 1  if swd > 7 [swd: 1] ; shift from mon=1 to sun=1
	ofs: (w - 1) * 7 + (wd - swd) ; offset
	d: fd + ofs ; date
	either d/month = m [d/day] [0] ; return day or zero!
]

mo: system/locale/months
tfw: 0 ; total five weekends
boring: 0 ; total boring years
awesome: 0 ; total owesome years

y: 1900  while [y <= 2100] [  fwy: 0 ; five weekends in year
	prin [y]
    foreach m [1 3 5 7 8 10 12] [
		if 1 = d: getday y m 1 6 [  fwy: fwy + 1
			prin [" " mo/:m]
        ]
    ]
	tfw: tfw + fwy
	either fwy > 0 [
		print [" ==> Five weekends: " fwy]
		if fwy > 1 [ awesome: awesome + 1]
	][
		boring: boring + 1
		print [" ==> Boring year!"]
	]
	y: y + 1
]
print ["Total five weekends: " tfw]
print ["Total boring years: " boring]
print ["Total years with multiple five weekends months: " awesome]
