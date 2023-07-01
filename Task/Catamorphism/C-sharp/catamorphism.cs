var nums = Enumerable.Range(1, 10);

int summation = nums.Aggregate((a, b) => a + b);

int product = nums.Aggregate((a, b) => a * b);

string concatenation = nums.Aggregate(String.Empty, (a, b) => a.ToString() + b.ToString());

Console.WriteLine("{0} {1} {2}", summation, product, concatenation);
