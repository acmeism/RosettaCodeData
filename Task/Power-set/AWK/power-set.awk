cat power_set.awk
#!/usr/local/bin/gawk -f

# User defined function
function tochar(l,n,	r) {
 while (l) { n--; if (l%2 != 0) r = r sprintf(" %c ",49+n); l = int(l/2) }; return r
}

# For each input
{ for (i=0;i<=2^NF-1;i++) if (i == 0) printf("empty\n"); else printf("(%s)\n",tochar(i,NF)) }
