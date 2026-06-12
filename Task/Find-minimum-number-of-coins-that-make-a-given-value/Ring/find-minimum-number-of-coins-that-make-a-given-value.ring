load "stdlib.ring"

see "working..." + nl
see "Coins are:" + nl
sum = 988

sumCoins = 0
coins = [1,2,5,10,20,50,100,200]
coins = reverse(coins)

for n = 1 to len(coins)
    nr = floor(sum/coins[n])
    if nr > 0
       sumCoins= nr*coins[n]
       sum -= sumCoins
       see "" + nr + "*" + coins[n] + nl
    ok
next

see "done..." + nl
