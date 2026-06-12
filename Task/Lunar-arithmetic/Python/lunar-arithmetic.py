#!/usr/bin/python3

def lunar_add(a, b='0'):
    a, b = str(a), str(b)
    max_len = max(len(a), len(b))
    a = '0' * (max_len - len(a)) + a
    b = '0' * (max_len - len(b)) + b
    return ''.join(str(max(int(x), int(y))) for x, y in zip(a, b))

def lunar_multiply(a, b='9'):
    if a == '0' or b == '0':
        return '0'

    a, b = str(a), str(b)
    result = '0'
    for i, digit in enumerate(reversed(b)):
        temp = ''.join(str(min(int(x), int(digit))) for x in a)
        temp += '0' * i
        result = lunar_add(result, temp)
    return result

def lunar_factorial(n):
    if n <= 1:
        return '1'
    result = '1'
    for i in range(2, n + 1):
        result = lunar_multiply(result, str(i))
    return result

def main():
    # Test cases
    test_cases = [(976, 348), (23, 321), (232, 35), (123, 32192, 415, 8)]

    for case in test_cases:
        # Lunar addition
        add_expr = ' 🌙+ '.join(str(x) for x in case)
        add_result = reduce(lunar_add, map(str, case))
        print(f"     Lunar add: {add_expr} == {add_result}")

        # Lunar multiplication
        mult_expr = ' 🌙× '.join(str(x) for x in case)
        mult_result = reduce(lunar_multiply, map(str, case))
        print(f"Lunar multiply: {mult_expr} == {mult_result}")
        print()

    # First 20 distinct lunar even numbers
    even_nums = []
    n = 0
    while len(even_nums) < 20:
        result = lunar_multiply(str(n), '2')
        if result not in even_nums:
            even_nums.append(result)
        n += 1
    print("First 20 distinct lunar even numbers:")
    print(' '.join(even_nums))
    print()

    # First 20 lunar square numbers
    squares = [lunar_multiply(str(i), str(i)) for i in range(20)]
    print("First 20 lunar square numbers:")
    print(' '.join(squares))
    print()

    # First 20 lunar factorial numbers
    factorials = [lunar_factorial(i) for i in range(20)]
    print("First 20 lunar factorial numbers:")
    print(' '.join(factorials))
    print()

    # First number whose lunar square is smaller than previous
    n = 1019  # We can start closer to the known solution
    while True:
        curr_square = lunar_multiply(str(n), str(n))
        next_square = lunar_multiply(str(n + 1), str(n + 1))
        if curr_square > next_square:
            print(f"First number whose lunar square is smaller than the previous: {n + 1}")
            break
        n += 1

if __name__ == '__main__':
    from functools import reduce
    main()
