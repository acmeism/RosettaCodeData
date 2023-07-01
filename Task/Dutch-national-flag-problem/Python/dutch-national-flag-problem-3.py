def dutch_flag_sort2(items, order=colours_in_order):
    'return summed filter of items using the given order'
    return [c for colour in order for c in items if c==colour]
