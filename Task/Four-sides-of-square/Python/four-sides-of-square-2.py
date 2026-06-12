def square(size=9):

    def is_at_border(row, col):
        # `&` is set intersection: if the set {row, col} intersects the set
        # {0, size-1}, then at least one of (row, col) is either 0 or size-1
        return {row, col} & {0, size-1}

    for row in range(size):
        print(' '.join(
            '1' if is_at_border(row, col) else '0'
            for col in range(size)
        ))

square()
