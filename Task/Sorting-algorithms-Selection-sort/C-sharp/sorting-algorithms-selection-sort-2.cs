String[] str = { "this", "is", "a", "test", "of", "generic", "selection", "sort" };

SelectionSort<String> mySort = new SelectionSort<string>();

String[] result = mySort.Sort(str);

for (int i = 0; i < result.Length; i++) {
    Console.WriteLine(result[i]);
}
