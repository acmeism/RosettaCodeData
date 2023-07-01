#!/usr/bin/awk -f
BEGIN {
    maxlen = 0;
    lenList = 0;
}

{
   if (length($0)>maxlen) {
	lenList = 1;
	List[lenList] = $0;
	maxlen = length($0);
   } else if (length($0)==maxlen)
	List[++lenList]=$0;
}	

END {
   for (k=1; k <= lenList; k++) print List[k];
}
