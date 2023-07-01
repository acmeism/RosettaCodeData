from itertools import chain
def dutch_flag_sort2(items, order=colours_in_order):
    'return summed filter of items using the given order'
    return list(chain.from_iterable(filter(lambda c: c==colour, items)
                                    for colour in order))
