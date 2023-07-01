base := {"name":"Rocket Skates", "price":12.75, "color":"yellow"}
update := {"price":15.25, "color":"red", "year":1974}
Merged := merge(base, update)
for k, v in Merged
	result .= k " : " v "`n"
MsgBox % result
