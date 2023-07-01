n=15
cat = list(n+2)
cat[1]=1
for i=1 to n
    for j=i+1 to 2 step -1
        cat[j]=cat[j]+cat[j-1]
    next
    cat[i+1]=cat[i]
    for j=i+2 to 2 step -1
        cat[j]=cat[j]+cat[j-1]
    next
    see "" + (cat[i+1]-cat[i]) + " "
next
