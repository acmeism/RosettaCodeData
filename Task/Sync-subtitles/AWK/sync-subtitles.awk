function change(h, m, s, ms,    seconds){
	seconds = modify + s + m*60 + h*60*60
	if (seconds<0){print "Went too far back" > "/dev/stderr"; exit 6 }
	h=seconds/60/60; m=seconds/60%60; s=seconds%60%60
	return sprintf("%.2i:%.2i:%.2i,%s", h, m, s, ms)
}

$2=="-->" {
	split($1,a,/[,:]/); $1=change(a[1],a[2],a[3],a[4])
	split($3,a,/[,:]/); $3=change(a[1],a[2],a[3],a[4])
}

1
