compose() {
	eval "$1() { $3 | $2; }"
}

downvowel() { tr AEIOU aeiou; }
upcase() { tr a-z A-Z; }
compose c downvowel upcase
echo 'Cozy lummox gives smart squid who asks for job pen.' | c
# => CoZY LuMMoX GiVeS SMaRT SQuiD WHo aSKS FoR JoB PeN.
