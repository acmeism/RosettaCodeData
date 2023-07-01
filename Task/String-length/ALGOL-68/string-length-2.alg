STRING str := "hello, world";
INT length := UPB str;
printf(($"Length of """g""" is "g(3)l$,str,length));

printf(($l"STRINGS can start at -1, in which case LWB must be used:"l$));
STRING s := "abcd"[@-1];
print(("s:",s, ", LWB:", LWB s, ", UPB:",UPB s, ", LEN:",UPB s - LWB s + 1))
