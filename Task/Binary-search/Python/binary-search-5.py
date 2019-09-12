index = bisect.bisect_left(list, item) # leftmost insertion point
index = bisect.bisect_right(list, item) # rightmost insertion point
index = bisect.bisect(list, item) # same as bisect_right

# same as above but actually insert the item into the list at the given place:
bisect.insort_left(list, item)
bisect.insort_right(list, item)
bisect.insort(list, item)
