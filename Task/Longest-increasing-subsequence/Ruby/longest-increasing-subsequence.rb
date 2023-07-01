Node = Struct.new(:val, :back)

def lis(n)
  pileTops = []
  # sort into piles
  for x in n
    # binary search
    low, high = 0, pileTops.size-1
    while low <= high
      mid = low + (high - low) / 2
      if pileTops[mid].val >= x
        high = mid - 1
      else
        low = mid + 1
      end
    end
    i = low
    node = Node.new(x)
    node.back = pileTops[i-1]  if i > 0
    pileTops[i] = node
  end

  result = []
  node = pileTops.last
  while node
    result.unshift(node.val)
    node = node.back
  end
  result
end

p lis([3, 2, 6, 4, 5, 1])
p lis([0, 8, 4, 12, 2, 10, 6, 14, 1, 9, 5, 13, 3, 11, 7, 15])
