def binarySearch(value):
  # To avoid copying the array, simply pass in the current low and high offsets
  def binarySearch(low; high):
      if (high < low) then (-1 - low)
      else ( (low + high) / 2 | floor) as $mid
           | if (.[$mid] > value) then binarySearch(low; $mid-1)
             elif (.[$mid] < value) then binarySearch($mid+1; high)
             else $mid
             end
      end;
   binarySearch(0; length-1);
