function binary_search(l, value, low = 1, high = -1)
  high == -1    &&  (high = length(l))
  l==[]         &&  (return -1)
  low >= high   &&
    ((low > high || l[low] != value) ? (return -1) : return low)
  mid = int((low+high)/2)
  l[mid] > value ? (return binary_search(l, value, low, mid-1))  :
    l[mid] < value ? (return binary_search(l, value, mid+1, high)) :
      return mid
end
