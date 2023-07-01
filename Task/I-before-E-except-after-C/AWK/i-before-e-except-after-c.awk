#!/usr/bin/awk -f

/.ei/ {nei+=cnt($3)}
/cei/ {cei+=cnt($3)}

/.ie/ {nie+=cnt($3)}
/cie/ {cie+=cnt($3)}

function cnt(c) {
	if (c<1) return 1;
	return c;
}

END {
	printf("cie: %i\nnie: %i\ncei: %i\nnei: %i\n",cie,nie-cie,cei,nei-cei);
	v = v2 = "";
	if (nie < 3 * cie) {
		v =" not";
	}
	print "I before E when not preceded by C: is"v" plausible";
	if (nei > 3 * cei)  {
		v = v2 =" not";
	}
	print "E before I when preceded by C: is"v2" plausible";
        print "Overall rule is"v" plausible";
}
