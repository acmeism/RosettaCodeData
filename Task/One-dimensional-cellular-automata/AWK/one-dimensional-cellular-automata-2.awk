Another new solution (twice size as previous solution) :
cat automata.awk :

#!/usr/local/bin/gawk -f

# User defined functions
function ASCII_to_Binary(str_) {
	gsub("_","0",str_); gsub("@","1",str_)
	return str_
}

function Binary_to_ASCII(bit_) {
	gsub("0","_",bit_); gsub("1","@",bit_)
	return bit_
}

function automate(b1,b2,b3) {
	a = and(b1,b2,b3)
	b = or(b1,b2,b3)
	c = xor(b1,b2,b3)
	d = a + b + c
	return d == 1 ? 1 : 0
}

# For each line in input do
{
str_ = $0
gen = 0
taille = length(str_)
print "0: " str_
do {
	gen ? str_previous = str_ : str_previous = ""
	gen += 1
	str_ = ASCII_to_Binary(str_)
	split(str_,tab,"")
	str_ = and(tab[1],tab[2])
	for (i=1; i<=taille-2; i++) {
		str_ = str_ automate(tab[i],tab[i+1],tab[i+2])
		}
	str_ = str_ and(tab[taille-1],tab[taille])
	print gen ": " Binary_to_ASCII(str_)
   } while (str_ != str_previous)
}
