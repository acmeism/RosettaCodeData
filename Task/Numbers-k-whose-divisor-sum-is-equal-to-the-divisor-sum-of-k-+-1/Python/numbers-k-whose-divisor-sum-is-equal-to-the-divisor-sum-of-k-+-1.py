#!/usr/bin/python3

import math

def sigma_sum(n):
    sum_divisors = 0

    for i in range(1, int(math.sqrt(n)) + 1):
        if n % i == 0:
            sum_divisors += i
            if i != n // i:
                sum_divisors += n // i

    return sum_divisors

def format_with_commas(n):
    return f"{n:,}"

def main():
    cnt = 0
    num = 0

    while cnt < 50:
        sigma_of_num = sigma_sum(num)
        sigma_of_next_num = sigma_sum(num + 1)

        if sigma_of_num == sigma_of_next_num:
            cnt += 1
            formatted_num = format_with_commas(num)

            print(f"{cnt}: {formatted_num}")

        num += 1

if __name__ == "__main__":
    main()
