#!/usr/local/bin/awk -f
  function countsubstring (str,pat)
  {
    n=0;	
    while (match(str,pat)) {
        n++;
	str = substr(str,RSTART+RLENGTH);    	
    }
    return n;
  }

  BEGIN {
    print countsubstring("the three truths","th");
    print countsubstring("ababababab","abab");
    print countsubstring(ARGV[1],ARGV[2]);
  }
