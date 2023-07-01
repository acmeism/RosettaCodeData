public int[,] Spiral(int n) {
    int[,] result = new int[n, n];

    int pos = 0;
    int count = n;
    int value = -n;
    int sum = -1;

    do {
        value = -1 * value / n;
        for (int i = 0; i < count; i++) {
            sum += value;
            result[sum / n, sum % n] = pos++;
        }
        value *= n;
        count--;
        for (int i = 0; i < count; i++) {
            sum += value;
            result[sum / n, sum % n] = pos++;
        }
    } while (count > 0);

    return result;
}


// Method to print arrays, pads numbers so they line up in columns
public void PrintArray(int[,] array) {
    int n = (array.GetLength(0) * array.GetLength(1) - 1).ToString().Length + 1;

    for (int i = 0; i < array.GetLength(0); i++) {
        for (int j = 0; j < array.GetLength(1); j++) {
            Console.Write(array[i, j].ToString().PadLeft(n, ' '));
        }
        Console.WriteLine();
    }
}
