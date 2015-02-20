fn compose f g {
	result @ {$g | $f}
}

fn downvowel {tr AEIOU aeiou}
fn upcase {tr a-z A-Z}
fn-c = <={compose $fn-downvowel $fn-upcase}
echo 'Cozy lummox gives smart squid who asks for job pen.' | c
# => CoZY LuMMoX GiVeS SMaRT SQuiD WHo aSKS FoR JoB PeN.
