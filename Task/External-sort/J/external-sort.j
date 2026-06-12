NB. Apply an in-place sorting algorithm to a memory mapped file
NB. in-place sort is translation of in-place python quicksort.

require 'jmf'
JCHAR map_jmf_ 'DATA'; 'file.huge'
NB. The noun DATA now refers to the memory mapped file.
NB. Use: quicksort DATA


NB. use: quicksort DATA
quicksort=: 3 :'qsinternal 0 , <:@:# ARRAY=: y'  NB. ARRAY is global

qsinternal=: 3 :0
 'start stop'=. y
 if. 0 < stop - start do.
  'left right pivot'=. start, stop, start{ARRAY   NB. pivot, left, right = array[start], start, stop
  while. left <: right do.           NB. while left <= right:
   while. pivot > left { ARRAY do.   NB. while array[left] < pivot:
    left=. >: left
   end.
   while. pivot < right { ARRAY do.  NB. while array[right] > pivot:
    right=. <: right                 NB. right -= 1
   end.
   if. left <: right do.             NB. if left <= right:

    NB. mapped files work by reference, assignment not required, but for testing.
    ARRAY=: (left, right) {`(|.@:[)`]} ARRAY NB. array[left], array[right] = array[right], array[left]

    left=. >: left                   NB. left += 1
    right=. <: right                 NB. right -= 1
   end.
  end.
  qsinternal start , right    NB. _quicksort(array, start, right)
  qsinternal left , stop      NB. _quicksort(array, left, stop)
 end.
 i. 0 0  NB. verbs return the final noun
)
