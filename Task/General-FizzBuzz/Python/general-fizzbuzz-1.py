def genfizzbuzz(factorwords, numbers):
    # sort entries by factor
    factorwords.sort(key=lambda factor_and_word: factor_and_word[0])
    lines = []
    for num in numbers:
        words = ''.join(word for factor, word in factorwords if (num % factor) == 0)
        lines.append(words if words else str(num))
    return '\n'.join(lines)

if __name__ == '__main__':
    print(genfizzbuzz([(5, 'Buzz'), (3, 'Fizz'), (7, 'Baxx')], range(1, 21)))
