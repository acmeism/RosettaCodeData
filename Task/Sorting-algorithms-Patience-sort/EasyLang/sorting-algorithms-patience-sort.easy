proc patience_sort &nums[] .
   for num in nums[]
      for p to len piles[][]
         if num >= piles[p][len piles[p][]]
            piles[p][] &= num
            break 1
         .
      .
      if p > len piles[][] : piles[][] &= [ num ]
   .
   for i to len nums[]
      dest = 1
      for p = 2 to len piles[][]
         if piles[p][1] < piles[dest][1] : dest = p
      .
      nums[i] = piles[dest][1]
      for j = 2 to len piles[dest][]
         piles[dest][j - 1] = piles[dest][j]
      .
      len piles[dest][] -1
      if len piles[dest][] = 0
         swap piles[dest][] piles[$][]
         len piles[][] -1
      .
   .
.
nums[] = [ 10 6 -30 9 18 1 -20 ]
patience_sort nums[]
print nums[]
