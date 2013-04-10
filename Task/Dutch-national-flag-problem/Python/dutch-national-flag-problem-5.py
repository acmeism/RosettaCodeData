import random

colours_in_order = 'Red White Blue'.split()

def dutch_flag_sort(items):
    '''\
    In-place sort of list items using the given order.
    Python idiom is to return None when argument is modified in-place

    O(n)? Algorithm from Go language implementation of
    http://www.csse.monash.edu.au/~lloyd/tildeAlgDS/Sort/Flag/'''

    lo, mid, hi = 0, 0, len(items)-1
    while mid <= hi:
        colour = items[mid]
        if colour == 'Red':
            items[lo], items[mid] = items[mid], items[lo]
            lo += 1
            mid += 1
        elif colour == 'White':
            mid += 1
        else:
            items[mid], items[hi] = items[hi], items[mid]
            hi -= 1

def dutch_flag_check(items, order=colours_in_order):
    'Return True if each item of items is in the given order'
    order_of_items = [order.index(item) for item in items]
    return all(x <= y for x, y in zip(order_of_items, order_of_items[1:]))

def random_balls(mx=5):
    'Select from 1 to mx balls of each colour, randomly'
    balls = sum(([[colour] * random.randint(1, mx)
                 for colour in colours_in_order]), [])
    random.shuffle(balls)
    return balls

def main():
    # Ensure we start unsorted
    while 1:
        balls = random_balls()
        if not dutch_flag_check(balls):
            break
    print("Original Ball order:", balls)
    dutch_flag_sort(balls)
    print("Sorted Ball Order:", balls)
    assert dutch_flag_check(balls), 'Whoops. Not sorted!'

if __name__ == '__main__':
    main()
