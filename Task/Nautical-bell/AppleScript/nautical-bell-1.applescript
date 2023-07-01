repeat
	set {hours:h, minutes:m} to (current date)
	if {0, 30} contains m then
		set bells to (h mod 4) * 2 + (m div 30)
                if bells is 0 then set bells to 4
                set pairs to bells div 2
		repeat pairs times
			say "ding dong" using "Bells"
		end repeat
		if (bells mod 2) is 1 then
			say "dong" using "Bells"
		end if
	end if
	delay 60
end repeat
