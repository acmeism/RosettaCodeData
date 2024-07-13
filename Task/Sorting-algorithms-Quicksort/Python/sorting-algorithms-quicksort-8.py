def quicksort(unsorted_list):
   if len(unsorted_list) == 0:
       return []
   pivot = unsorted_list[0]
   less = list(filter(lambda x: x <  pivot, unsorted_list))
   same = list(filter(lambda x: x == pivot, unsorted_list))
   more = list(filter(lambda x: x >  pivot, unsorted_list))

   return quicksort(less) + same + quicksort(more)
