from collections import defaultdict

N = 100
FACTOR_TO_WORD = {
    3: "Fizz",
    5: "Buzz",
}

def fizzbuzz(n=N, factor_to_word=FACTOR_TO_WORD):

    factors = defaultdict(list)

    for factor in factor_to_word:
        factors[factor].append(factor)

    for i in range(1, n+1):
        res = ''
        for factor in sorted(factors.pop(i, ())):
            factors[i+factor].append(factor)
            res += factor_to_word[factor]
        yield res or i

if __name__ == '__main__':

    n = int(input('Enter number: '))

    mods = {
      int(k): v
      for k, v in (
        input('Enter "<factor> <word>" (without quotes): ').split(maxsplit=1)
        for _ in range(3)
      )
    }

    for line in fizzbuzz(n, mods):
        print(line)
