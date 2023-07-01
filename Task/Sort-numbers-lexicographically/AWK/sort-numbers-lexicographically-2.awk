BEGIN {
    n=13
    for (i=1; i<=n; i++)
        a[i]=i""
    asort(a)
    for (k in a)
        printf "%d ", a[k]
}
