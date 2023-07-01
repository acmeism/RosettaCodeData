# syntax: GAWK -f HEX_WORDS.AWK unixdict.txt
{   nf += NF
    if (length($1) >= 4) {
      if ($0 ~ /^[a-fA-F]{4,}$/) {
        base10 = hex2dec($1)
        dr = digital_root(base10)
        arr[dr " " $1] = base10
      }
    }
}
ENDFILE {
    printf("%s: %d records, %d fields\n\n",FILENAME,FNR,nf)
}
END {
    PROCINFO["sorted_in"] = "@ind_str_asc"
    for (i in arr) {
      printf("%-8s %10d \n",i,arr[i])
      count1++
    }
    printf("Found %d hex words\n\n",count1)
    PROCINFO["sorted_in"] = "@val_num_desc"
    for (i in arr) {
      if (distinct(substr(i,3)) >= 4) {
        printf("%-8s %10d \n",i,arr[i])
        count2++
      }
    }
    printf("Found %d hex words with 4 or more distinct\n\n",count2)
    exit(0)
}
function digital_root(n,  i,sum) {
    while (1) {
      sum = 0
      for (i=1; i<=length(n); i++) {
        sum += substr(n,i,1)
      }
      if (sum < 10) {
        break
      }
      n = sum
    }
    return(sum)
}
function distinct(str,  arr,i) {
    for (i=1; i<=length(str); i++) {
      arr[substr(str,i,1)]++
    }
    return(length(arr))
}
function hex2dec(s,  num) {
    num = index("0123456789ABCDEF",toupper(substr(s,length(s)))) - 1
    sub(/.$/,"",s)
    return num + (length(s) ? 16*hex2dec(s) : 0)
}
