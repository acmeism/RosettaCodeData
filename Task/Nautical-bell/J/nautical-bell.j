require 'strings printf'

WATCH        =:  <;._1 ' Middle Morning Forenoon Afternoon Dog First'
ORDINAL      =:  <;._1 ' One Two Three Four Five Six Seven Eight'
BELL         =:  7{a.  NB. Terminal bell code (\a or ^G)

time         =:  6!:0
sleep        =:  6!:3
print        =:  ucp 1!:2 4:

shipsWatch   =:  verb define
	PREV_MARK =.  _1 _1
	while. do. NB. Loop forever
		now  =.  3 4 { time ''  NB. Current hour & minute
		
		NB. If we just flipped over to a new half-hour mark
		if. (0 30 e.~ {: now) > now -: PREV_MARK do.
			PREV_MARK  =. now
			'allsWell notes'=.callWatch now			
			
			print allsWell
			(ringBell"0~ -@# {. 2|#) notes
			print CRLF
		end.
		
		sleep 15.0
	end.	
)

callWatch    =:  verb define
	'watch bells' =. clock2ship y
	
	NB. Plural for 0~:bells ordinals are origin-1, not origin-0
	NB. (and similarly 1+bells for notes).
	fields=.(0{y);(1{y);(watch{::WATCH);(bells{::ORDINAL);('s'#~0~:bells)
	notes =. ; (0 2#:1+bells) #&.> u:16b266b 16b266a NB. ♫♪
	
	notes ;~ '%02d:%02d %s watch, %s Bell%s Gone: \t' sprintf fields
)
	
clock2ship   =: verb define"1
	NB. Convert from "24 hours of 60 minutes" to
	NB. "6 watches of 8 bells", and move midnight
	NB. from index-origin 0 (0 hrs, 0 minutes)
	NB. index-origin 1 (0 watches, 1 bell).
	6 8 #: 48 | _1 + 24 2 #. (, (30-1)&I.)/ y	
)

ringBell     =:  dyad define
	print BELL,y

	NB. x indicates two rings (0) or just one (1)
	if. 0=x do.
		sleep 0.75
		print BELL
		sleep 0.25
	else.
		sleep 1.0
	end.
	y
)
