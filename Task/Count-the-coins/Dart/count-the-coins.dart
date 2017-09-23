var cache = new Map();

main() {
    var stopwatch = new Stopwatch()..start();

    // use the brute-force recursion for the small problem
    int amount = 100;
    list coinTypes = [25,10,5,1];
    print (coins(amount,coinTypes).toString() + " ways for $amount using $coinTypes coins.");

    // use the cache version for the big problem
    amount = 100000;
    coinTypes = [100,50,25,10,5,1];
    print (cachedCoins(amount,coinTypes).toString() + " ways for $amount using $coinTypes coins.");

    stopwatch.stop();
    print ("... completed in " + (stopwatch.elapsedMilliseconds/1000).toString() + " seconds");
}


coins(int amount, list coinTypes) {
    int count = 0;

    if(coinTypes.length == 1) return (1);   // just pennies available, so only one way to make change

    for(int i=0; i<=(amount/coinTypes[0]).toInt(); i++){                // brute force recursion
      count += coins(amount-(i*coinTypes[0]),coinTypes.sublist(1));     // sublist(1) is like lisp's '(rest ...)'
    }

    // uncomment if you want to see intermediate steps
    //print("there are " + count.toString() +" ways to count change for ${amount.toString()} using ${coinTypes} coins.");
    return(count);
  }


  cachedCoins(int amount, list coinTypes) {
      int count = 0;

      // this is more efficient, looks at last two coins.  but not fast enough for the optional exercise.
      if(coinTypes.length == 2) return ((amount/coinTypes[0]).toInt() + 1);

      var key = "$amount.$coinTypes";         // lookes like "100.[25,10,5,1]"
      var cacheValue = cache[key];            // check whether we have seen this before

      if(cacheValue != null) return(cacheValue);

      count = 0;
      // same recursion as simple method, but caches all subqueries too
      for(int i=0; i<=(amount/coinTypes[0]).toInt(); i++){
        count += cachedCoins(amount-(i*coinTypes[0]),coinTypes.sublist(1));     // sublist(1) is like lisp's '(rest ...)'
      }

      cache[key] = count;                     // add this to the cache
      return(count);
    }
