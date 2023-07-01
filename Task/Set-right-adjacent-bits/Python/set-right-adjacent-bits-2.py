from typing import List


def set_right_adjacent_bits_list(n: int, b: List[int]) -> List[int]:
    #   [0]*x is padding b on the left.
    #   zip(*(list1, list2,..)) returns the n'th elements on list1, list2,...
    #   int(any(...)) or's them.
    return [int(any(shifts))
            for shifts in zip(*([0]*x + b for x in range(n+1)))]

def _list2bin(b: List[int]) -> str:
    "List of 0/1 ints to bool string."
    return ''.join(str(x) for x in b)

def _to_list(bits: str) -> List[int]:
    return [int(char) for char in bits]

if __name__ == "__main__":
    print("SAME n & Width.\n")
    n = 2  # bits to the right of set bits, to also set
    bits = "1000 0100 0010 0000"
    first = True
    for b_str in bits.split():
        b = _to_list(b_str)
        e = len(b_str)
        if first:
            first = False
            print(f"n = {n}; Width e = {e}:\n")
        result = set_right_adjacent_bits_list(n, b)
        print(f"     Input b: {_list2bin(b)}")
        print(f"      Result: {_list2bin(result)}\n")

    print("SAME Input & Width.\n")
    #bits = "01000010001001010110"
    bits = '01' + '1'.join('0'*x for x in range(10, 0, -1))
    for n in range(4):
        first = True
        for b_str in bits.split():
            b = _to_list(b_str)
            e = len(b_str)
            if first:
                first = False
                print(f"n = {n}; Width e = {e}:\n")
                result = set_right_adjacent_bits_list(n, b)
            print(f"     Input b: {_list2bin(b)}")
            print(f"      Result: {_list2bin(result)}\n")
