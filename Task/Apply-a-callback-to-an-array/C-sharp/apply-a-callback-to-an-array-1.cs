int[] intArray = { 1, 2, 3, 4, 5 };
// Simplest method:  LINQ, functional
int[] squares1 = intArray.Select(x => x * x).ToArray();

// Slightly fancier: LINQ, query expression
int[] squares2 = (from x in intArray
                  select x * x).ToArray();

// Or, if you only want to call a function on each element, just use foreach
foreach (var i in intArray)
    Console.WriteLine(i * i);
