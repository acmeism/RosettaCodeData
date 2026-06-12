def ends_with_one(n: int):
    while True:
        sumation = 0
        while n > 0:
            digit = n % 10
            sumation += digit ** 2
            n //= 10

        if sumation == 1:
            return True

        if sumation == 89:
            return False

        n = sumation

def main():
    ks = [7, 8, 11, 14, 17]

    for k in ks:
        sums = [0] * (k * 81 + 1)
        sums[0] = 1

        for n in range(1, k+1):
            for i in range(n * 81, 0, -1):
                for j in range(1, 10):
                    s = j ** 2
                    if s > i:
                        break

                    sums[i] += sums[i - s]

        count1 = 0

        for i in range(1, k * 81 + 1):
            if ends_with_one(i):
                count1 += sums[i]

        limit = 10 ** k - 1
        print(f'For k = {k} in the range 1 to {limit}')
        print(f'{count1} numbers produce 1 and {limit - count1} numbers produce 89\n')

if __name__ == '__main__':
    main()
