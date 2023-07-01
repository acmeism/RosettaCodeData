# syntax: GAWK -f EQUILIBRIUM_INDEX.AWK
BEGIN {
    main("-7 1 5 2 -4 3 0")
    main("2 4 6")
    main("2 9 2")
    main("1 -1 1 -1 1 -1 1")
    exit(0)
}
function main(numbers,  x) {
    x = equilibrium(numbers)
    printf("numbers: %s\n",numbers)
    printf("indices: %s\n\n",length(x)==0?"none":x)
}
function equilibrium(numbers,  arr,i,leftsum,leng,str,sum) {
    leng = split(numbers,arr," ")
    for (i=1; i<=leng; i++) {
      sum += arr[i]
    }
    for (i=1; i<=leng; i++) {
      sum -= arr[i]
      if (leftsum == sum) {
        str = str i " "
      }
      leftsum += arr[i]
    }
    return(str)
}
