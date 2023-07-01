tell (the current date)
	set shortdate to text 1 thru 10 of (it as «class isot» as string)
	set longdate to the contents of [its weekday, ", ", ¬
		(its month), " ", day, ", ", year] as text
end tell

log the shortdate
log the longdate
