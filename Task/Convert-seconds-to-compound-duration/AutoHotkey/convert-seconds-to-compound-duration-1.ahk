duration(n){
	sec:=1, min:=60*sec, hr:=60*min, day:=24*hr, wk:=7*day
	w	:=n//wk		, n:=Mod(n,wk)
	d	:=n//day	, n:=Mod(n,day)
	h	:=n//hr		, n:=Mod(n,hr)
	m	:=n//min	, n:=Mod(n,min)
	s	:=n
	return trim((w?w " wk, ":"") (d?d " d, ":"") (h?h " hr, ":"") (m?m " min, ":"") (s?s " sec":""),", ")
}
