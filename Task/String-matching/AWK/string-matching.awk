#!/usr/bin/awk -f
{ pos=index($2,$1)
 print $2, (pos==1 ? "begins" : "does not begin" ), "with " $1
 print $2, (pos ? "contains an" : "does not contain" ), "\"" $1 "\""
 if (pos) {
	l=length($1)
	Pos=pos
	s=$2
	while (Pos){
		print " " $1 " is at index", x+Pos
		x+=Pos
		s=substr(s,Pos+l)
		Pos=index(s,$1)
	}
 }
 print $2, (substr($2,pos)==$1 ? "ends" : "does not end"), "with " $1
}
