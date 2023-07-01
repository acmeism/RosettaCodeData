from collections import Counter
from re import findall

les_mis_file = 'les_mis_135-0.txt'

def _count_words(fname):
    with open(fname) as f:
        text = f.read()
    words = findall(r'\w+', text.lower())
    return Counter(words)

def most_common_words_in_file(fname, n):
    counts = _count_words(fname)
    for word, count in [['WORD', 'COUNT']] + counts.most_common(n):
        print(f'{word:>10} {count:>6}')


if __name__ == "__main__":
    n = int(input('How many?: '))
    most_common_words_in_file(les_mis_file, n)
