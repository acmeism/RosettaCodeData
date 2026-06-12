import random
import time

# Type aliases for better readability
Vector = list[int]
Matrix = list[list[int]]
Cube = list[list[list[int]]]


def to_reduced(m: Matrix) -> Matrix:
    """Reduces a matrix to a specific form by swapping rows and columns."""
    n = len(m)
    r = [row[:] for row in m]  # Create a deep copy of the matrix

    # Ensure first row is [0, 1, 2, ...] by swapping columns
    for j in range(n - 1):
        if r[0][j] != j:
            for k in range(j + 1, n):
                if r[0][k] == j:
                    for i in range(n):
                        r[i][j], r[i][k] = r[i][k], r[i][j]
                    break

    # Ensure first column is [0, 1, 2, ...] by swapping rows
    for i in range(1, n - 1):
        if r[i][0] != i:
            for k in range(i + 1, n):
                if r[k][0] == i:
                    for j in range(n):
                        r[i][j], r[k][j] = r[k][j], r[i][j]
                    break

    return r


def print_matrix(m: Matrix) -> None:
    """Prints a matrix with elements incremented by 1 (for 1-based indexing)."""
    n = len(m)
    for i in range(n):
        for j in range(n):
            print(f"{m[i][j] + 1:2d} ", end="")
        print()
    print()


def as_array_16(m: Matrix) -> list[int]:
    """Converts a 4x4 matrix into a 1D array."""
    a = [0] * 16
    k = 0
    for i in range(4):
        for j in range(4):
            a[k] = m[i][j]
            k += 1
    return a


def as_array_25(m: Matrix) -> list[int]:
    """Converts a 5x5 matrix into a 1D array."""
    a = [0] * 25
    k = 0
    for i in range(5):
        for j in range(5):
            a[k] = m[i][j]
            k += 1
    return a


def print_array_16(a: list[int]) -> None:
    """Prints a 1D array as a 4x4 matrix with elements incremented by 1."""
    for i in range(4):
        for j in range(4):
            k = i * 4 + j
            print(f"{a[k] + 1:2d} ", end="")
        print()
    print()


def shuffle_cube(c: Cube) -> None:
    """Shuffles a cube in-place using a specific algorithm."""
    n = len(c[0])
    proper = True
    rx, ry, rz = 0, 0, 0
    while True:
        rx = random.randint(0, n - 1)
        ry = random.randint(0, n - 1)
        rz = random.randint(0, n - 1)
        if c[rx][ry][rz] == 0:
            break

    while True:
        ox, oy, oz = 0, 0, 0
        while ox < n:
            if c[ox][ry][rz] == 1:
                break
            ox += 1
        if not proper and random.random() < 0.5:
            ox += 1
            while ox < n:
                if c[ox][ry][rz] == 1:
                    break
                ox += 1

        while oy < n:
            if c[rx][oy][rz] == 1:
                break
            oy += 1
        if not proper and random.random() < 0.5:
            oy += 1
            while oy < n:
                if c[rx][oy][rz] == 1:
                    break
                oy += 1

        while oz < n:
            if c[rx][ry][oz] == 1:
                break
            oz += 1
        if not proper and random.random() < 0.5:
            oz += 1
            while oz < n:
                if c[rx][ry][oz] == 1:
                    break
                oz += 1

        c[rx][ry][rz] += 1
        c[rx][oy][oz] += 1
        c[ox][ry][oz] += 1
        c[ox][oy][rz] += 1

        c[rx][ry][oz] -= 1
        c[rx][oy][rz] -= 1
        c[ox][ry][rz] -= 1
        c[ox][oy][oz] -= 1

        if c[ox][oy][oz] < 0:
            rx, ry, rz = ox, oy, oz
            proper = False
        else:
            proper = True
            break


def to_matrix(c: Cube) -> Matrix:
    """Converts a cube to a matrix."""
    n = len(c[0])
    m = [[0] * n for _ in range(n)]
    for i in range(n):
        for j in range(n):
            for k in range(n):
                if c[i][j][k] != 0:
                    m[i][j] = k
                    break
    return m


def make_cube(from_matrix: Matrix | None, n: int) -> Cube:
    """Creates a cube from a matrix or initializes it with a default pattern."""
    c = [[[0] * n for _ in range(n)] for _ in range(n)]
    for i in range(n):
        for j in range(n):
            if from_matrix is None:
                k = (i + j) % n
            else:
                k = from_matrix[i][j] - 1
            c[i][j][k] = 1
    return c


def main():
    random.seed()  # Seed using system time

    # Part 1
    print("PART 1: 10,000 latin Squares of order 4 in reduced form:\n")
    from_matrix = [[1, 2, 3, 4], [2, 1, 4, 3], [3, 4, 1, 2], [4, 3, 2, 1]]
    freqs4: dict[tuple[int, ...], int] = {}  # Use tuple for hashable array representation
    c = make_cube(from_matrix, 4)
    for _ in range(10000):
        shuffle_cube(c)
        m = to_matrix(c)
        rm = to_reduced(m)
        a16 = as_array_16(rm)
        a16_tuple = tuple(a16)  # Convert list to tuple for use as dictionary key
        freqs4[a16_tuple] = freqs4.get(a16_tuple, 0) + 1  # Increment frequency

    for a_tuple, freq in freqs4.items():
        a = list(a_tuple) # Convert back to list for printing
        print_array_16(a)
        print(f"Occurs {freq} times\n")

    # Part 2
    print("\nPART 2: 10,000 latin squares of order 5 in reduced form:")
    from_matrix = [[1, 2, 3, 4, 5], [2, 3, 4, 5, 1], [3, 4, 5, 1, 2],
                   [4, 5, 1, 2, 3], [5, 1, 2, 3, 4]]
    freqs5: dict[tuple[int, ...], int] = {}
    c = make_cube(from_matrix, 5)
    for _ in range(10000):
        shuffle_cube(c)
        m = to_matrix(c)
        rm = to_reduced(m)
        a25 = as_array_25(rm)
        a25_tuple = tuple(a25)
        freqs5[a25_tuple] = freqs5.get(a25_tuple, 0) + 1

    count = 0
    output_str = ""
    for _, freq in freqs5.items():
        count += 1
        if count > 1:
            output_str += ", "
        if (count - 1) % 8 == 0:
            output_str += "\n"
        output_str += f"{count:2d}({freq:3d})"

    print(output_str)
    print("\n")

    # Part 3
    print("\nPART 3: 750 latin squares of order 42, showing the last one:\n")
    m42: Matrix = []
    c = make_cube(None, 42)
    for i in range(1, 751):
        shuffle_cube(c)
        if i == 750:
            m42 = to_matrix(c)

    print_matrix(m42)

    # Part 4
    print("\nPART 4: 1000 latin squares of order 256:\n")
    start_time = time.time()
    c = make_cube(None, 256)
    for _ in range(1000):
        shuffle_cube(c)

    elapsed_time = time.time() - start_time
    print(f"Generated in {elapsed_time:.4f} seconds\n")


if __name__ == "__main__":
    main()
