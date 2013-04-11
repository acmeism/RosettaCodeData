BEGIN { FS="" }
{for(i=1;i<=NF;i++) m[$i]++}END{for(i in m)printf("%9d %-14s\n",m[i],i)}

usage: awk -f letters.awk HolyBible.txt
