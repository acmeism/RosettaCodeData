// helper function to pretty print an Iterable
String iterableToString(Iterable seq) {
  String str = "[";
  Iterator i = seq.iterator;
  if (i.moveNext()) str += i.current.toString();
  while(i.moveNext()) {
    str += ", " + i.current.toString();
  }
  return str + "]";
}

main() {
  int limit = 1000;
  int strt = new DateTime.now().millisecondsSinceEpoch;
  Set<int> sieve = new Set<int>();

  for(int i = 2; i <= limit; i++) {
    sieve.add(i);
  }
  for(int i = 2; i * i <= limit; i++) {
   if(sieve.contains(i)) {
     for(int j = i * i; j <= limit; j += i) {
       sieve.remove(j);
     }
   }
  }
  var sortedValues = new List<int>.from(sieve);
  int elpsd = new DateTime.now().millisecondsSinceEpoch - strt;
  print("Found " + sieve.length.toString() + " primes up to " + limit.toString() +
      " in " + elpsd.toString() + " milliseconds.");
  print(iterableToString(sortedValues)); // expect sieve.length to be 168 up to 1000...
//  Expect.equals(168, sieve.length);
}
