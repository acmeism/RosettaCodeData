using System.Diagnostics;

const string cypher = "ADFGVX";
var N = cypher.Length;
var size = N * N;
const string symbols = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
Debug.Assert(size == symbols.Length);
var square = new int[size];

for (var i = 0; i < size; i++)
{
    var j = Random.Shared.Next(i + 1);
    square[i] = square[j];
    square[j] = i;
}

Console.WriteLine($"{N} x {N} Polybius square:");
Console.WriteLine();
Console.WriteLine($"  | {string.Join(' ', cypher.AsEnumerable())}");
Console.WriteLine(new string('-', 2 * N + 3));

for (var row = 0; row < N; row++)
{
    Console.Write($"{cypher[row]} |");

    for (var col = 0; col < N; col++)
    {
        Console.Write($" {symbols[square[col + row * N]]}");
    }

    Console.WriteLine();
}

static bool IsSuitableTranspositionKey(string s) =>
    s.Length >= 7 && s.Length <= 12 && s.Length == s.Distinct().Count() && s.All(symbols.ToLowerInvariant().Contains);

var keys = File.ReadAllLines("unixdict.txt").Where(IsSuitableTranspositionKey).ToArray();
var key = keys[Random.Shared.Next(keys.Length)].ToUpperInvariant();
Console.WriteLine();
Console.WriteLine($"The key is {key}");
var plaintext = "ATTACKAT1200AM";
Console.WriteLine($"Plaintext: {plaintext}");

string Encrypt(string plaintext, string key, int[] square)
{
    // Create a lookup table from symbol to fragment
    var map = (from i in Enumerable.Range(0, size)
               let k = square[i]
               let code = cypher[i / N] + "" + cypher[i % N]
               select (k, code))
               .ToDictionary(kc => symbols[kc.k], kc => kc.code);

    // Map the plaintext to fragments
    var e = string.Join("", plaintext.Select(c => map[c]));

    // Determine number of rows
    var K = key.Length;
    var rows = (e.Length + K - 1) / K;

    // Pad with spaces
    e += new string(' ', rows * K - e.Length);

    // Sort the key
    var order = string.Join("", key.OrderBy(c => c)).Select(c => key.IndexOf(c)).ToArray();

    // Reorder the fragments.
    e = string.Join("", Enumerable.Range(0, K * rows).Select(i => e[(i / K) * K + order[i % K]]));

    // Transpose
    e = new([.. from col in Enumerable.Range(0, K)
                from row in Enumerable.Range(0, rows)
                select e[row * K + col]]);

    // Read off each column.
    return string.Join(" ", Enumerable.Range(0, K).Select(col => e.Substring(col * rows, rows).Trim()));
}

var encrypted = Encrypt(plaintext, key, square);
Console.WriteLine($"Encrypted: {encrypted}");

string Decrypt(string encrypted, string key, int[] square)
{
    // Create a lookup table from fragment to symbol
    var map = (from i in Enumerable.Range(0, size)
               let k = square[i]
               let code = cypher[i / N] + "" + cypher[i % N]
               select (k, code))
               .ToDictionary(kc => kc.code, kc => symbols[kc.k]);

    // Split into columns
    var cols = encrypted.Split(' ');

    // Determine number of rows
    var K = key.Length;
    var rows = cols.Max(c => c.Length);

    // Pad each column
    cols = [.. cols.Select(c => c.PadRight(rows))];

    // Transpose
    string e = new([.. from row in Enumerable.Range(0, rows)
                       from col in Enumerable.Range(0, K)
                       select cols[col][row]]);

    // Sort the key
    var sorted = string.Join("", key.OrderBy(c => c));
    var order = key.Select(c => sorted.IndexOf(c)).ToArray();

    // Reorder the fragments
    e = string.Join("", Enumerable.Range(0, K * rows).Select(i => e[(i / K) * K + order[i % K]])).Trim();

    // Map the fragments to plaintext
    return string.Join("", Enumerable.Range(0, e.Length / 2).Select(i => map[e.Substring(2 * i, 2)]));
}

var decrypted = Decrypt(encrypted, key, square);
Console.WriteLine($"Decrypted: {decrypted}");
