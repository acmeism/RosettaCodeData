defmodule RC do
  def find_miss_perm(head, perms) do
    all_permutations(head) -- perms
  end

  defp all_permutations(string) do
    list = String.split(string, "", trim: true)
    Enum.map(permutations(list), fn x -> Enum.join(x) end)
  end

  defp permutations([]), do: [[]]
  defp permutations(list), do: (for x <- list, y <- permutations(list -- [x]), do: [x|y])
end

perms = ["ABCD", "CABD", "ACDB", "DACB", "BCDA", "ACBD", "ADCB", "CDAB", "DABC", "BCAD", "CADB", "CDBA",
         "CBAD", "ABDC", "ADBC", "BDCA", "DCBA", "BACD", "BADC", "BDAC", "CBDA", "DBCA", "DCAB"]

IO.inspect RC.find_miss_perm( hd(perms), perms )
