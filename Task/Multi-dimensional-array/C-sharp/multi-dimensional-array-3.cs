var array = (int[,,,])Array.CreateInstance(typeof(int), new [] { 5, 4, 3, 2 }, new [] { 10, 10, 10, 10 });
int n = 1;
//Note: GetUpperBound is inclusive
for (int a = array.GetLowerBound(0); a <= array.GetUpperBound(0); a++)
for (int b = array.GetLowerBound(1); b <= array.GetUpperBound(1); b++)
for (int c = array.GetLowerBound(2); c <= array.GetUpperBound(2); c++)
for (int d = array.GetLowerBound(3); d <= array.GetUpperBound(3); d++)
    array[a, b, c, d] = n++;

//To set the first value, we must now use the lower bounds:
array[10, 10, 10, 10] = 999;
//As with all arrays, Length gives the TOTAL length.
Console.WriteLine("Length: " + array.Length);
Console.WriteLine("First 30 elements:");
//The multidimensional array does not implement the generic IEnumerable<int>
//so we need to cast the elements.
Console.WriteLine(string.Join(" ",  array.Cast<int>().Take(30)) + " ...");
