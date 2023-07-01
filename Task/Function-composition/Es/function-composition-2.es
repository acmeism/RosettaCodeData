fn compose f g {
	result @ x {result <={$f <={$g $x}}}
}

fn downvowel x {result `` '' {tr AEIOU aeiou <<< $x}}
fn upcase x {result `` '' {tr a-z A-Z <<< $x}}
fn-c = <={compose $fn-downvowel $fn-upcase}
echo <={c 'Cozy lummox gives smart squid who asks for job pen.'}
# => CoZY LuMMoX GiVeS SMaRT SQuiD WHo aSKS FoR JoB PeN.
