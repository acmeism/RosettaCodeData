from math import ceil, log10, factorial

def next_step(x):
    result = 0
    while x > 0:
        result += (x % 10) ** 2
        x /= 10
    return result

def check(number):
    candidate = 0
    for n in number:
        candidate = candidate * 10 + n

    while candidate != 89 and candidate != 1:
        candidate = next_step(candidate)

    if candidate == 89:
        digits_count = [0] * 10
        for d in number:
            digits_count[d] += 1

        result = factorial(len(number))
        for c in digits_count:
            result /= factorial(c)
        return result

    return 0

def main():
    limit = 100000000
    cache_size = int(ceil(log10(limit)))
    assert 10 ** cache_size == limit

    number = [0] * cache_size
    result = 0
    i = cache_size - 1

    while True:
        if i == 0 and number[i] == 9:
            break
        if i == cache_size - 1 and number[i] < 9:
            number[i] += 1
            result += check(number)
        elif number[i] == 9:
            i -= 1
        else:
            number[i] += 1
            for j in xrange(i + 1, cache_size):
                number[j] = number[i]
            i = cache_size - 1
            result += check(number)

    print result

main()
