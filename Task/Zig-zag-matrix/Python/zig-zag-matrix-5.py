from __future__ import print_function

import math


def zigzag( dimension):
    ''' generate the zigzag indexes for a square array
        Exploiting the fact that an array is symmetrical around its
        centre
    '''
    NUMBER_INDEXES = dimension ** 2
    HALFWAY = NUMBER_INDEXES // 2
    KERNEL_ODD = dimension & 1

    xy = [0 for _ in range(NUMBER_INDEXES)]
    # start at 0,0
    ix = 0
    iy = 0
    # 'fake' that we are going up and right
    direction = 1
    # the first index is always 0, so start with the second
    # until halfway
    for i in range(1, HALFWAY + KERNEL_ODD):
        if direction > 0:
            # going up and right
            if iy == 0:
                # are at top
                ix += 1
                direction = -1
            else:
                ix += 1
                iy -= 1
        else:
            # going down and left
            if ix == 0:
                # are at left
                iy += 1
                direction = 1
            else:
                ix -= 1
                iy += 1
        # update the index position
        xy[iy * dimension + ix] = i

    # have first half, but they are scattered over the list
    # so find the zeros to replace
    for i in range(1, NUMBER_INDEXES):
        if xy[i] == 0 :
            xy[i] = NUMBER_INDEXES - 1 - xy[NUMBER_INDEXES - 1 - i]

    return xy


def main(dim):
    zz = zigzag(dim)
    print( 'zigzag of {}:'.format(dim))
    width = int(math.ceil(math.log10(dim**2)))
    for j in range(dim):
        for i in range(dim):
            print('{:{width}}'.format(zz[j * dim + i], width=width), end=' ')
        print()


if __name__ == '__main__':
    main(5)
