import "./math" for Int

var pairs = [[21,15],[17,23],[36,12],[18,29],[60,15]]
System.print("The following pairs of numbers are coprime:")
for (pair in pairs) if (Int.gcd(pair[0], pair[1]) == 1) System.print(pair)
