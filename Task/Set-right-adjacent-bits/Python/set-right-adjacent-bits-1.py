from operator import or_
from functools import reduce

def set_right_adjacent_bits(n: int, b: int) -> int:
    return reduce(or_, (b >> x for x in range(n+1)), 0)


if __name__ == "__main__":
    print("SAME n & Width.\n")
    n = 2  # bits to the right of set bits, to also set
    bits = "1000 0100 0010 0000"
    first = True
    for b_str in bits.split():
        b = int(b_str, 2)
        e = len(b_str)
        if first:
            first = False
            print(f"n = {n}; Width e = {e}:\n")
        result = set_right_adjacent_bits(n, b)
        print(f"     Input b: {b:0{e}b}")
        print(f"      Result: {result:0{e}b}\n")

    print("SAME Input & Width.\n")
    #bits = "01000010001001010110"
    bits = '01' + '1'.join('0'*x for x in range(10, 0, -1))
    for n in range(4):
        first = True
        for b_str in bits.split():
            b = int(b_str, 2)
            e = len(b_str)
            if first:
                first = False
                print(f"n = {n}; Width e = {e}:\n")
            result = set_right_adjacent_bits(n, b)
            print(f"     Input b: {b:0{e}b}")
            print(f"      Result: {result:0{e}b}\n")
