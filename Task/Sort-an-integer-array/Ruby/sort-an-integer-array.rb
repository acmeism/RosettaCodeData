nums = [2,4,3,1,2]
sorted = nums.sort      # returns a new sorted array.  'nums' is unchanged
p sorted                #=> [1, 2, 2, 3, 4]
p nums                  #=> [2, 4, 3, 1, 2]

nums.sort!              # sort 'nums' "in-place"
p nums                  #=> [1, 2, 2, 3, 4]
