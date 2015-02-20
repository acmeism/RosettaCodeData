# usage:  awk -v list1="i ii iii" -v list2="1 2 3"  -f hash2.awk
BEGIN {
	if(!list1) list1="one two three"
	if(!list2) list2="1 2 3"
		
        split(list1, a);
        split(list2, b);
        for(i=1;i in a;i++) { c[a[i]] = b[i] };

        for(i in c) print i,c[i]
}
