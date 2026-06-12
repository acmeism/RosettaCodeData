from sympy import isprime

def main():
    num_count = 1

    for num in range(4, 100_000):
        count = 1

        for divisor in range(1, (num // 2) + 1):
            if num % divisor == 0:
                count += 1

        if count > 2 and isprime(count):
            print("%6d" % num, end=' ')

            if num_count % 5 == 0:
                print()

            num_count += 1

if __name__ == '__main__':
    main()
