/// Provides the same result and performance as the Dart 1 version
/// but using the Dart 2 specifications.
Map<String, int> cache = {};

void main() {
  Stopwatch stopwatch = Stopwatch()..start();

  /// Use the brute-force recursion for the small problem
  int amount = 100;
  List<int> coinTypes = [25,10,5,1];
  print ("${coins(amount,coinTypes)} ways for $amount using $coinTypes coins.");

  /// Use the cache version for the big problem
  amount = 100000;
  coinTypes = [100,50,25,10,5,1];
  print ("${cachedCoins(amount,coinTypes)} ways for $amount using $coinTypes coins.");

  stopwatch.stop();
  print ("... completed in ${stopwatch.elapsedMilliseconds/1000} seconds");

}

int cachedCoins(int amount, List<int> coinTypes) {
  int count = 0;

  /// This is more efficient, looks at last two coins.
  /// But not fast enough for the optional exercise.
  if(coinTypes.length == 2) return (amount ~/ coinTypes[0] + 1);

  /// Looks like "100.[25,10,5,1]"
  String key = "$amount.$coinTypes";
  /// Check whether we have seen this before
  var cacheValue = cache[key];

  if(cacheValue != null) return(cacheValue);

  count = 0;
  /// Same recursion as simple method, but caches all subqueries too
  for(int i=0; i<=amount ~/ coinTypes[0]; i++){
    count += cachedCoins(amount-(i*coinTypes[0]),coinTypes.sublist(1));     // sublist(1) is like lisp's '(rest ...)'
  }

  /// add this to the cache
  cache[key] = count;
  return count;
}

int coins(int amount, List<int> coinTypes) {
  int count = 0;

  /// Just pennies available, so only one way to make change
  if(coinTypes.length == 1) return (1);

  /// Brute force recursion
  for(int i=0; i<=amount ~/ coinTypes[0]; i++){
    /// sublist(1) is like lisp's '(rest ...)'
    count += coins(amount - (i*coinTypes[0]),coinTypes.sublist(1));
  }

  /// Uncomment if you want to see intermediate steps
  /// print("there are " + count.toString() +" ways to count change for ${amount.toString()} using ${coinTypes} coins.");
  return count;
}
