function cmp(i1, v1, i2, v2, u1, u2) {
	u1 = v1""v2;
	u2 = v2""v1;
        return (u2 - u1)
}
function largest_int_from_concatenated_ints(X) {
 	PROCINFO["sorted_in"]="cmp";
	u="";
	for (i in X) u=u""X[i];
	return u
}

BEGIN {
	split("1 34 3 98 9 76 45 4",X);
	print largest_int_from_concatenated_ints(X)

	split("54 546 548 60",X);
	print largest_int_from_concatenated_ints(X)
}
