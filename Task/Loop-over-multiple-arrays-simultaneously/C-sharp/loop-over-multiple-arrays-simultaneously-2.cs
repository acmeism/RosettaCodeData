int[] numbers = { 1, 2, 3, 4 };
string[] words = { "one", "two", "three" };
Console.WriteLine(numbers.Zip(words, (first, second) => first + " " +
 second));
