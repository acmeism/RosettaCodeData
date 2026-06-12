# syntax: GAWK -f FIND_MINIMUM_NUMBER_OF_COINS_THAT_MAKE_A_GIVEN_VALUE.AWK
BEGIN {
    n = split("200,100,50,20,10,5,2,1",arr,",")
    main(988)
    main(388)
    main(0)
    exit(0)
}
function main(arg1,  amount,coins,denomination,i,remaining,total) {
    amount = remaining = int(arg1)
    for (i=1; i<=n; i++) {
      denomination = arr[i]
      coins = 0
      while (remaining >= denomination) {
        remaining -= denomination
        coins++
      }
      total += coins
      printf("%4d x %2d = %d\n",denomination,coins,denomination*coins)
    }
    printf("%9d coins needed to disperse %s\n\n",total,arg1)
}
