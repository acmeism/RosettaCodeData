def makechange(denominations = [1,2,5,10,20,50,100,200], total = 988):
    print(f"Available denominations: {denominations}. Total is to be: {total}.")
    coins, remaining = sorted(denominations, reverse=True), total
    for n in range(len(coins)):
        coinsused, remaining = divmod(remaining, coins[n])
        if coinsused > 0:
            print("   ", coinsused, "*", coins[n])

makechange()
