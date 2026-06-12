nums = [[1,2,0], [3,4,-1,1], [7,8,9,11,12], [1,2,3,4,5],
        [-6,-5,-2,-1], [5,-5], [-2], [1], []]

for n = 1 to len(nums)
      see "the smallest missing positive integer for "
      ? (arrayToStr(nums[n]) + ": " + fmp(nums[n]))
next

func fmp(ary)
      if len(ary) > 0
            for m = 1 to max(ary) + 1
                  if find(ary, m) < 1 return m ok
            next ok return 1

func arrayToStr(ary)
      res = "[" s = ","
      for n = 1 to len(ary)
            if n = len(ary) s = "" ok
            res += "" + ary[n] + s
      next return res + "]"
