do shell script "echo '
define juggler(n) {
    #auto temp,i,max,pos
    #scale = 0;
    temp = n; i = 0; max = n; pos = i;
    while (temp > 1) {
        i = i + 1; temp = sqrt(temp ^ (1 + (temp % 2 * 2)));
        if (temp > max) { max = temp; pos = i; }
    }
    if (n < 40) {
        print n,\": l[n] = \",i,\", h[n] = \",max, \", i[n] = \",pos,\"\\n\";
    } else {
        print n,\": l[n] = \",i,\", d[n] = \",length(max), \", i[n] = \",pos,\"\\n\";
    }
    return;
}

for (n = 20 ; n < 40 ; n++) { juggler(n); }
print \"\\n\";
juggler(113); juggler(173); juggler(193); juggler(2183); juggler(11229); juggler(15065);
juggler(15845); # 91 seconds so far.
juggler(30817); # Another 191 to here.
# juggler(48443) produced no result after running all night.
' | bc | sed -n '/^0$/ !p;'"
