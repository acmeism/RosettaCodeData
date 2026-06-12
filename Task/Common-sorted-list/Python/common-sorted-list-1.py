def sorted_union(*nums):
    return sorted(set().union(*nums))

print(sorted_union([5, 1, 3, 8, 9, 4, 8, 7], [3, 5, 9, 8, 4], [1, 3, 7, 9]))
