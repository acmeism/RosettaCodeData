circlesort = (arr, lo, hi, swaps) ->
  if lo == hi
     return (swaps)

  high = hi
  low  = lo
  mid = Math.floor((hi-lo)/2)

  while lo < hi
    if arr[lo] > arr[hi]
       t = arr[lo]
       arr[lo] = arr[hi]
       arr[hi] = t
       swaps++
    lo++
    hi--

  if lo == hi
     if arr[lo] > arr[hi+1]
        t = arr[lo]
        arr[lo] = arr[hi+1]
        arr[hi+1] = t
        swaps++

  swaps = circlesort(arr,low,low+mid,swaps)
  swaps = circlesort(arr,low+mid+1,high,swaps)

  return(swaps)

VA = [2,14,4,6,8,1,3,5,7,9,10,11,0,13,12,-1]

while circlesort(VA,0,VA.length-1,0)
   console.log VA
