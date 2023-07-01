def dutch_flag_sort3(items, order=colours_in_order):
    'counts each colour to construct flag'
    return sum([[colour] * items.count(colour) for colour in order], [])
