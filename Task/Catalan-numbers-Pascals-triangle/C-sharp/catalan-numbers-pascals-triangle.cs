int n = 15;
List<int> t = new List<int>() { 0, 1 };
for (int i = 1; i <= n; i++)
{
    for (var j = i; j > 1; j--) t[j] += t[j - 1];
    t.Add(t[i]);
    for (var j = i + 1; j > 1; j--) t[j] += t[j - 1];
    Console.Write(((i == 1) ? "" : ", ") + (t[i + 1] - t[i]));
}
