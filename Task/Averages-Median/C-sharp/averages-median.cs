double median(double[] arr)
{
	var sorted = arr.OrderBy(x => x).ToList();
	var mid = arr.Length / 2;
	return arr.Length % 2 == 0
		? (sorted[mid] + sorted[mid-1]) / 2
		: sorted[mid];
}

var write = (double[] x) =>
	Console.WriteLine($"[{string.Join(", ", x)}]: {median(x)}");
write(new double[] { 1, 5, 3, 6, 4, 2 }); //even
write(new double[] { 1, 5, 3, 6, 4, 2, 7 }); //odd
write(new double[] { 5 }); //single
