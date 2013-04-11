int[] nums = { 1, 1, 2, 3, 4, 4 };
List<int> unique = new List<int>();
foreach (int n in nums)
    if (!unique.Contains(n))
        unique.Add(n);
