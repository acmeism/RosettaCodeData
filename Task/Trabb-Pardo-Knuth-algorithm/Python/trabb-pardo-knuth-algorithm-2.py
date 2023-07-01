import math

def f(x):
    return math.sqrt(abs(x)) + 5 * x**3

def ask_numbers(n=11):
    print(f'Enter {n} numbers:')
    return (float(input('>')) for _ in range(n))

if __name__ == '__main__':
    for x in ask_numbers().reverse():
        if (result := f(x)) > 400:
            print(f'f({x}): overflow')
        else:
            print(f'f({x}) = {result}')
